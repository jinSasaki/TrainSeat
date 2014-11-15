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

    for (UIButton *btn in self.positionBtnsInCar) {
        btn.backgroundColor = RGBA(255, 219, 179, 61);
    }

}

- (void)alertWithMessage:(NSString *)message {
    
}

- (IBAction)decideButtonDidPush:(id)sender {

    
    // validation
    
    if (!self.carSegument.selectedSegmentIndex) {
        [self alertWithMessage:@"車両が入力されていません"];
    }
    if (!self.sittingStatusSegment.selectedSegmentIndex) {
        [self alertWithMessage:@"乗車状態が入力されていません"];
    }
    if (!self.selectedPositionNum) {
        [self alertWithMessage:@"乗車位置が入力されていません"];
    }
    
    self.trainInfo.carNumber = (int)self.carSegument.selectedSegmentIndex;
    
    // traininfoの保存
    TrainInfoManager *trainInfoManager = [TrainInfoManager defaultTrainInfoManager];
    trainInfoManager.userTrainInfo.carNumber = (int)self.carSegument.selectedSegmentIndex;
    trainInfoManager.userTrainInfo.position = self.selectedPositionNum;
    trainInfoManager.userTrainInfo.isSittng = (BOOL) self.sittingStatusSegment.selectedSegmentIndex;
    
    // 完了のアラート
    [self alertWithMessage:@"登録しました"];
    LOG(@"save train info");
    
    // 送信
    [trainInfoManager requestToSET];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (IBAction)positioonBtnDidPush:(id)sender {
    
    for (UIButton *btn in self.positionBtnsInCar) {
        btn.backgroundColor = RGBA(255, 219, 179, 61);
    }
    UIButton *pushedBtn = sender;
    pushedBtn.backgroundColor = RGBA(194, 194, 194 , 61 );
    self.selectedPositionNum = [pushedBtn.currentTitle intValue];
    LOG(@"%d did pushed",self.selectedPositionNum);
}
@end
