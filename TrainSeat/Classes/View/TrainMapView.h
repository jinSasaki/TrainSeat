//
//  TrainMapView.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RailwayMapView.h"
#import "RailwayManager.h"
#import "StationButton.h"
#import "LocationManager.h"

@interface TrainMapView : UIView
{
    int count;
}

@property (nonatomic) UIView *staionsMap;
@property (nonatomic) UIView *railwayMap;
@property (nonatomic) UIView *trainMap;

@property (nonatomic) NSDictionary *groupStations;
@property (nonatomic) NSDictionary *stationDict;

+ (double)maxWidth;
+ (double)maxHeight;
- (NSDictionary *)matchList;

- (RailwayMapView *)railwaymapWithRailwayName:(NSString *)railwayName;
- (RailwayMapView *)railwaymapWithTitle:(NSString *)title;

- (void)groupStationsOnRailways:(NSArray *)railways;

- (void)nonSelectedStatusAllStations:(double)alpha;
- (void)selectedStaionOnRailway:(Railway *)railway alpha:(double)alpha;

- (void)updateTrainMapView;

@end
