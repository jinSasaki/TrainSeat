//
//  PassengerViewController.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/16.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "PassengerViewController.h"

@interface PassengerViewController ()

@end

@implementation PassengerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.manager = [TrainInfoManager defaultTrainInfoManager];
    self.manager.delegate = self;
    
    [self test];
    
    [self.manager requestToGET];
    
    // ボタンの色
    RGBA(194, 194, 194 , 61 );
    
    
    
}

- (void)test {
    NSDictionary *dict = @{@"train_code": @"XXXXXX"};
    TrainInfo *testCase = [[TrainInfo alloc]initWithDict:dict];
    self.manager.userTrainInfo = testCase;
}

- (void)trainInfoManager:(TrainInfoManager *)manager didRecievedTrainInfos:(NSArray *)trainInfos {
    for (TrainInfo *trainInfo in trainInfos) {
        LOG(@"%@",trainInfo.trainCode);
    }
}

@end
