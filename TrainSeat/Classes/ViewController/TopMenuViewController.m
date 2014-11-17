//
//  TopMenuViewController.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "TopMenuViewController.h"

@interface TopMenuViewController ()
@end

@implementation TopMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.railwayManager = [RailwayManager defaultManager];
    self.trainInfoManager = [TrainInfoManager defaultTrainInfoManager];
    if (!self.trainInfoManager.userTrainInfo) {
        // disable get button
        self.trainInfoButton.enabled = NO;
    }else {
        self.trainInfoButton.enabled = YES;
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

@end
