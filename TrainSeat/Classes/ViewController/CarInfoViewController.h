//
//  CarInfoViewController.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/01.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainInfo.h"
#import "RailwayManager.h"
#import "UserManager.h"

@interface CarInfoViewController : UIViewController

@property TrainInfo *trainInfo;

@property IBOutlet UISegmentedControl *carSegument;

@property  IBOutletCollection(UIButton)NSArray *positionsInCar;

@property IBOutlet UIPickerView *optionalInfo;

- (IBAction)decideButtonDidPush:(id)sender;

@end
