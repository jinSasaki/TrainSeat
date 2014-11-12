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

@property (nonatomic , weak) TrainInfo *trainInfo;

@property (nonatomic , weak) IBOutlet UISegmentedControl *directionSegment;
@property (nonatomic , weak) IBOutlet UISegmentedControl *statusSegment;
@property (nonatomic , weak) IBOutlet UIPickerView *pickerview;

@end
