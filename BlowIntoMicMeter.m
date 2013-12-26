//
//  BlowIntoMicMeter.m
//  BlowToMic
//
//  Created by Ali ElSayed on 9/20/13.
//  Copyright (c) 2013 Aperture Mobile. All rights reserved.
//

#import "BlowIntoMicMeter.h"

@implementation BlowIntoMicMeter

- (id) init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(16, 38, 320 - 32, 66); // Right where the real slide to power off will end up
        _bgColor = [UIColor purpleColor];
        _meterColor = [UIColor orangeColor];
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _bgColor = [UIColor purpleColor];
        _meterColor = [UIColor orangeColor];
        [self initialize];
    }
    return self;
}

- (void) initialize
{
    self.backgroundColor = _bgColor;
    self.layer.cornerRadius = 6.0;
    self.clipsToBounds = YES;
    // self.alpha = 0.75;
    
    micMeter = [[UIView alloc] initWithFrame:CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    micMeter.backgroundColor = _meterColor;
    
    [self addSubview:micMeter];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"blow into mic to snooze";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24.0];
    [self addSubview:_titleLabel];
    
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
  	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                              nil];
    
  	NSError *error;
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: &error];
    if (error)
    {
        NSLog(@"%@", [error description]);
    }
  	
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
  	if (recorder)
    {
  		[recorder prepareToRecord];
  		recorder.meteringEnabled = YES;
  		[recorder record];
        levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03
                                                      target: self
                                                    selector: @selector(levelTimerCallback:)
                                                    userInfo: nil
                                                     repeats: YES];
  	}
    else
    {
  		NSLog(@"%@", [error description]);
    }

}

- (void)levelTimerCallback:(NSTimer *)timer {
	[recorder updateMeters];
    
	const double ALPHA = 0.05;
	double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
    
	NSLog(@"Average input: %f Peak input: %f Low pass results: %f", [recorder averagePowerForChannel:0], [recorder peakPowerForChannel:0], lowPassResults);

    if (lowPassResults > 0.80) {
        if (micMeter.frame.origin.x + lowPassResults < 0) {
            micMeter.frame = CGRectMake(micMeter.frame.origin.x + lowPassResults,
                                        micMeter.frame.origin.y,
                                        micMeter.frame.size.width,
                                        micMeter.frame.size.height);
        }
        else
        {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{micMeter.frame = CGRectMake(0, micMeter.frame.origin.y, micMeter.frame.size.width, micMeter.frame.size.height);} completion:^(BOOL finished) {[levelTimer invalidate];}];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
