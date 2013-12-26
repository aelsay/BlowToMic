//
//  ViewController.m
//  BlowToMic
//
//  Created by Ali ElSayed on 9/20/13.
//  Copyright (c) 2013 Aperture Mobile. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    micMeter = [[BlowIntoMicMeter alloc] initWithFrame:CGRectMake(16, 38 + 66, 320 - 32, 66)];
    [self.view addSubview:micMeter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
