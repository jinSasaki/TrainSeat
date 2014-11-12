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

@property (nonatomic) NSArray *allRailway;
@property (nonatomic) NSDictionary *allRailwayDict;

@property (nonatomic) NSArray *allStation;
@property (nonatomic) NSDictionary *allStationDict;
@property (nonatomic , weak) id <RailwayManagerDelegate> delegate;

+ (instancetype)defaultManager;
- (void)updateRailwayInfomation;

- (NSArray *)loadTimeTableOfStation:(Station *)station;


- (NSString *)stationTitleWithStationName:(NSString *)staitonName;

@end
