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

- (void)didStartUpdateing;
- (void)didRecieve;

@optional

- (void)didError:(NSError *)error;

@end

@interface LocationManager : NSObject <ConnectionDelegate>
{
    NSTimer *timer;
}
@property (nonatomic , weak) id <LocationManagerDelegate> delegate;

@property (nonatomic) Railway *currentRailway;

@property (nonatomic, copy) NSDictionary *railwayDirections;

@property (nonatomic, copy) NSArray *trainArray;

+ (instancetype)defaultManager;

- (void)startConnectionWithRailway:(Railway *)railway;
- (void)stopConnection;

- (Train *)trainWithUCode:(NSString *)ucode;
@end
