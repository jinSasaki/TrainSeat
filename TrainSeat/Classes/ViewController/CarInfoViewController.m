//
//  CarInfoViewController.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/01.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "CarInfoViewController.h"

@interface CarInfoViewController ()

@end

@implementation CarInfoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    UserManager *uManager = [UserManager defaultUserManager];
    if (uManager.currentTrainInfo) {
        self.carSegument.selectedSegmentIndex = uManager.currentTrainInfo.carNumber;
    }
}


- (IBAction)decideButtonDidPush:(id)sender {

    self.trainInfo.carNumber = self.carSegument.selectedSegmentIndex;
    
    // traininfoの保存
    UserManager *uManager = [UserManager defaultUserManager];
    [uManager setCurrentTrainInfo:self.trainInfo];
    
    // 完了のアラート
    NSLog(@"%@",self.trainInfo);
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
