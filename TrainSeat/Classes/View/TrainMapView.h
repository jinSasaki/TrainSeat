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
#import "TrainView.h"

@interface TrainMapView : UIView
{
    int count;
}

@property (nonatomic , weak) UIView *staionsMap;
@property (nonatomic , weak) UIView *railwayMap;
@property (nonatomic , weak) UIView *trainMap;

@property (nonatomic , weak) NSDictionary *groupStations;
@property (nonatomic , weak) NSDictionary *stationDict;

@property (nonatomic , weak) NSString *currentDirection;

+ (double)maxWidth;
+ (double)maxHeight;
- (NSDictionary *)matchList;

- (RailwayMapView *)railwaymapWithRailwayName:(NSString *)railwayName;
- (RailwayMapView *)railwaymapWithTitle:(NSString *)title;

- (void)groupStationsOnRailways:(NSArray *)railways;

- (void)nonSelectedStatusAllStations:(double)alpha;
- (void)selectedStaionOnRailway:(Railway *)railway alpha:(double)alpha;

- (void)updateTrainMapView;

- (void)updateTrainMapViewWithRailDirection:(NSString *)direction;

@end
