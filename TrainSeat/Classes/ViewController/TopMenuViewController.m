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
    self.mapButton.layer.cornerRadius = 10.0;
    RailwayManager *manager;
    manager = [RailwayManager defaultManager];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

@end
