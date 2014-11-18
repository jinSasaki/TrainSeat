//
//  RailwayManager.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "RailwayManager.h"

@implementation RailwayManager

// シングルトンでいつでも同じものを返す
// singleton
static RailwayManager *shareManager = nil;
+ (instancetype)defaultManager {
    
    if (!shareManager) {
        shareManager = [RailwayManager new];
        
    }
    return shareManager;
}

- (id)init {
    self = [super init];
    if (self) {
        // ロード中

        if ([self.delegate respondsToSelector:@selector(didStartGettingRailwayData)]) {
            [self.delegate didStartGettingRailwayData];
        }
    
        [self loadRailwayInfomation];
        
        // ロード終わり
        if ([self.delegate respondsToSelector:@selector(didEndGettingRailwayData)]) {
            [self.delegate didEndGettingRailwayData];
        }
    }
    return self;
}

- (void)loadRailwayInfomation {
    
    Connection *connection = [Connection new];
    // あえて同期で通信
    NSData *data;
    NSArray *jsonArray;

    /**
     * 路線を取得
     */

    NSMutableArray *railwayArray = [NSMutableArray array];
    NSMutableDictionary *railwayDictionay = [NSMutableDictionary dictionary];
    // 全路線を取得
    data = [connection connectBySynchronousRequestWithOdptType:OdptRailway andQuery:nil];
    jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

    data = [connection connectBySynchronousRequestWithOdptType:OdptStation andQuery:nil];
    NSArray *stationsJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

    NSMutableDictionary *allStations = [NSMutableDictionary dictionary];
                                   
    // 駅の全配列をつくる
    for (NSDictionary *stationDict in stationsJSON) {
        Station *station = [[Station alloc]initWithDictionary:stationDict];
        [allStations setObject:station forKey:station.sameAs];
    }
    for (NSDictionary *railwayDict in jsonArray) {
        NSMutableArray *stationArray = [NSMutableArray array];
        NSMutableDictionary *stationDict = [NSMutableDictionary dictionary];

        // 路線インスタンスの生成
        Railway *railway = [[Railway alloc]initWithDictionary:railwayDict];
        
        for (NSString *stationCode in railway.order) {
            // 路線の駅順配列から駅を取得
            // 駅インスタンスの生成
            Station *station = [allStations objectForKey:stationCode];
            [stationArray addObject:station];
            [stationDict setObject:station forKey:station.stationName];
        }

        railway.stationArray = stationArray;
        railway.stationDict = stationDict;

        [railwayArray addObject:railway];
        [railwayDictionay setObject:railway forKey:railway.railwayName];
    }
    
    
    self.allRailway = railwayArray;
    self.allRailwayDict = railwayDictionay;
    
    self.allStations = allStations;
    
    LOG(@"=============connection is finished=================");
}


@end
