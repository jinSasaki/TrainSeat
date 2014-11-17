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

// 全路線情報
@property (nonatomic, copy) NSArray *allRailway;

//
@property (nonatomic, copy) NSDictionary *allRailwayDict;

// 全駅情報
@property (nonatomic, copy) NSDictionary *allStations;

// ユーザの選択中の路線
@property (nonatomic) Railway *userRailway;

@property (nonatomic, weak) id <RailwayManagerDelegate> delegate;

// シングルトンを返す
+ (instancetype)defaultManager;

// 路線情報の更新
- (void)updateRailwayInfomation;

// 時刻表の読み込み（通信）
- (NSArray *)loadTimeTableOfStation:(Station *)station;

@end
