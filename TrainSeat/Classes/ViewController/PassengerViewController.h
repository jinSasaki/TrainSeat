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
#import "RailwayManager.h"
#import "LocationManager.h"

@interface PassengerViewController : UIViewController
<TrainInfoManagerDelegate , UIScrollViewDelegate>

@property (nonatomic) TrainInfoManager *trainInfoManager;
@property (nonatomic) RailwayManager *railwayManager;
@property (nonatomic) LocationManager *locationManager;

@property (nonatomic) IBOutletCollection(UIButton) NSArray *positionBtns;
@property (nonatomic ,weak) IBOutlet UISegmentedControl *carSegement;
@property (nonatomic ,weak) IBOutlet UIScrollView *stationScrollView;

@property (nonatomic ,weak) IBOutlet UILabel *railwayLabel;
@property (nonatomic ,weak) IBOutlet UILabel *directionLabel;
@property (nonatomic ,weak) IBOutlet UILabel *dropNumLabel;
@property (nonatomic ,weak) IBOutlet UILabel *openSeatNumLabel;

@property (nonatomic ,weak) IBOutlet UIImageView *arrowImageView;

@property (nonatomic ,weak) IBOutlet UILabel *carLabel;

@property (nonatomic) NSInteger index;
- (IBAction)changeCarNumber:(id)sender;


@end
    