//
//  LineTableViewController.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/14.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RailwayManager.h"
#import "LocationManager.h"
#import "TrainInfoManager.h"

#import "LineTableViewCell.h"
#import "LineButton.h"

@interface LineTableViewController : UITableViewController
<LocationManagerDelegate>

@property LocationManager *locationManager;
@property RailwayManager *railwayManager;
@property Railway *currentRailway;


@property (nonatomic) UIScrollView *lineScrollView;

@property Station *selectedStation;
@property NSString *selectedTrainCode;

@property NSDictionary *upTrains;
@property NSDictionary *downTrains;

- (IBAction)trainDidPush:(id)sender;

@end
