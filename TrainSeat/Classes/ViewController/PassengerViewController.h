//
//  PassengerViewController.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/16.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainInfoManager.h"
#import "TrainInfo.h"

@interface PassengerViewController : UIViewController
<TrainInfoManagerDelegate>

@property (nonatomic)TrainInfoManager *manager;
@property (nonatomic ,weak) IBOutletCollection(UIButton)NSArray *positionBtns;
@property (nonatomic ,weak) IBOutlet UISegmentedControl *carSegement;
@property (nonatomic ,weak) IBOutlet UIScrollView *stationScrollView;
- (IBAction)changeCarNumber:(id)sender;


@end
    