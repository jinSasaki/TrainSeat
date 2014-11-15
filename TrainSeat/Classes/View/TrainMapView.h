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

@property (nonatomic) UIView *stationsMap;
@property (nonatomic) UIView *railwayMap;
@property (nonatomic) UIView *trainMap;

@property (nonatomic, copy) NSDictionary *groupStations;
@property (nonatomic, copy) NSDictionary *stationDict;

@property (nonatomic, copy) NSString *currentDirection;
@property (nonatomic) Railway *currentRailway;

@property (nonatomic) NSString *selectedTrainUCode;
@property (nonatomic) StationButton *selectedStationButton;

@property (nonatomic) UIImageView *pinView;
@property (nonatomic) UIImageView *flagView;

- (NSDictionary *)matchList;

- (RailwayMapView *)railwaymapWithRailwayName:(NSString *)railwayName;


- (void)updateTrainMapView;

- (void)updateTrainMapViewWithRailDirection:(NSString *)direction;

@end
