//
//  TrainInfoViewController.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection+TokyoMetroAPI.h"
#import "RailwayManager.h"
#import "CarInfoViewController.h"
#import "Timetable.h"

@interface TrainInfoViewController : UIViewController
<UIPickerViewDataSource ,UIPickerViewDelegate>

@property (nonatomic) TrainInfo *trainInfo;


@property (nonatomic) IBOutlet UISegmentedControl *directionSegment;
@property (nonatomic) IBOutlet UISegmentedControl *statusSegment;
@property (nonatomic) IBOutlet UIPickerView *pickerview;


@end
