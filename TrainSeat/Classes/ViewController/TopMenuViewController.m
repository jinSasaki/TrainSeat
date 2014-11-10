//
//  TopMenuViewController.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "TopMenuViewController.h"

@interface TopMenuViewController ()
{
    RailwayManager *manager;
}
@end

@implementation TopMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    manager = [RailwayManager defaultManager];
    
}

@end
