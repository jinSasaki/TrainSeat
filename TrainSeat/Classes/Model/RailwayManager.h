//
//  RailwayManager.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Connection+TokyoMetroAPI.h"
#import "Railway.h"
#import "Station.h"
#import "TrainInfo.h"

@class RailwayManager;

@protocol RailwayManagerDelegate <NSObject>

- (void)didUpdateRailwayInformation;

@end


@interface RailwayManager : NSObject <ConnectionDelegate>

@property (nonatomic, copy) NSArray *allRailway;
@property (nonatomic, copy) NSDictionary *allRailwayDict;

@property (nonatomic, copy) NSArray *allStation;
@property (nonatomic, copy) NSDictionary *allStationDict;
@property (nonatomic) id <RailwayManagerDelegate> delegate;

+ (instancetype)defaultManager;
- (void)updateRailwayInfomation;

- (NSArray *)loadTimeTableOfStation:(Station *)station;


- (NSString *)stationTitleWithStationName:(NSString *)staitonName;


@end
