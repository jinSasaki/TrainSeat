//
//  LocationManager.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/11.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Connection+TokyoMetroAPI.h"
#import "Railway.h"
#import "Train.h"
#import "RailwayManager.h"

@class LocationManager;

@protocol LocationManagerDelegate <NSObject>

- (void)didRecieve;

@end

@interface LocationManager : NSObject <ConnectionDelegate>
{
    NSTimer *timer;
}
@property id <LocationManagerDelegate> delegate;

@property (nonatomic , weak) Railway *currentRailway;

@property (nonatomic , weak) NSDictionary *railwayDirections;

@property (nonatomic , weak) NSArray *trainArray;

+ (instancetype)defaultManager;

- (void)startConnectionWithRailway:(Railway *)railway;
- (void)stopConnection;

@end
