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
#import "LineTableViewCell.h"
@interface LineTableViewController : UITableViewController

@property LocationManager *locationManager;
@property RailwayManager *railwayManager;
@property Railway *currentRailway;

@end
