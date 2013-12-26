//
//  BlowIntoMicMeter.h
//  BlowToMic
//
//  Created by Ali ElSayed on 9/20/13.
//  Copyright (c) 2013 Aperture Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AVFoundation/AVFoundation.h>

@interface BlowIntoMicMeter : UIControl
{
    UIView *micMeter;
    double lowPassResults;
    AVAudioRecorder *recorder;
    NSTimer *levelTimer;
}

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIColor *bgColor;
@property (strong, nonatomic) UIColor *meterColor;

@end
