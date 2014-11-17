//
//  TopMenuViewController.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RailwayManager.h"
#import "TrainInfoViewController.h"

@interface TopMenuViewController : UIViewController
@property (nonatomic) TrainInfoManager *trainInfoManager;
@property (nonatomic) RailwayManager *railwayManager;
@property (nonatomic,weak) IBOutlet UIButton *tableButton;
@property (nonatomic,weak) IBOutlet UIButton *trainInfoButton;
@end
