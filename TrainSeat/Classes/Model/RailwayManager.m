//
//  RailwayManager.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "RailwayManager.h"


#warning check todo
// TODO: userDefault
// 内部的にいろんな一覧を蓄えておく
// UserDefaultに蓄える

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
        [self loadRailwayInfomation];
        // ロード終わり
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
    // デリゲートに通知
    if ([self.delegate respondsToSelector:@selector(didUpdateRailwayInformation)]) {
        [self.delegate didUpdateRailwayInformation];
    }

//    // すべての駅を取得
//    NSMutableArray *stationArray = [NSMutableArray array];
//    NSMutableDictionary *__allstationDict = [NSMutableDictionary dictionary];
//    
//    data = [connection connectBySynchronousRequestWithOdptType:OdptStation andQuery:nil];
//    jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//
//    for (NSDictionary *stationDict in jsonArray) {
//        Station *station = [[Station alloc]initWithDictionary:stationDict];
//        [stationArray addObject:station];
//        [__allstationDict setObject:station forKey:station.stationName];
//    }
//    
//    self.allStationDict = __allstationDict;
//    self.allStation = stationArray;
//    
//    
//    // すべての路線を取得
//    NSMutableArray *railwayArray = [NSMutableArray array];
//    NSMutableDictionary *railwayDictionay = [NSMutableDictionary dictionary];
//    data = [connection connectBySynchronousRequestWithOdptType:OdptRailway andQuery:nil];
//    jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//
//    // Railwayインスタンスをセット
//    for (NSDictionary *railwayDict in jsonArray) {
//        Railway *railway = [[Railway alloc]initWithDictionary:railwayDict];
//        
//        // 路線に一致する駅のみ抽出
//        NSMutableArray *array = [NSMutableArray array];
//        for (Station *station in stationArray) {
//            if ([railway.code compare:station.railwayCode] == NSOrderedSame) {
//                [array addObject:station];
//            }
//        }
//        railway.stations = array;
//
//        [railwayArray addObject:railway];
//        [railwayDictionay setObject:railway forKey:railway.railwayName];
//
//
//    }
//    
//    self.allRailway = railwayArray;
//    self.allRailwayDict = railwayDictionay;
//    
//    if ([self.delegate respondsToSelector:@selector(didUpdateRailwayInformation)]) {
//        [self.delegate didUpdateRailwayInformation];
//    }
}

// APIを叩いて路線・駅情報を最新版に更新する
- (void)updateRailwayInfomation {
    Connection *connection = [Connection new];
    [connection sendRequestWithOdptType:OdptRailway];
    connection.delegate = self;
}



- (NSArray *)loadTimeTableOfStation:(Station *)station withRailway:(Railway *)railway andDirection:(UserDirection)direction {
    

    // 方向と路線を指定して取得
    
    return nil;
}

- (NSArray *)loadTimeTableOfStation:(Station *)station {
    
    Connection *connection = [Connection new];

    // クエリで
    NSData *data = [connection connectBySynchronousRequestWithOdptType:OdptStationTimeTable andQuery:nil];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    return jsonArray;
    
}



#pragma mark - connection delegate

- (void)connection:(Connection *)connection didConnectionError:(NSError *)error {
    
}

- (void)connection:(Connection *)connection didRecieve:(NSData *)recievedData {
    // 受け取ったデータをStationやRailwayクラスにキャストして保存する
    // ここがとっても複雑？あるいはdictごと渡してStationとかにやらせる？
    
    LOG(@"connection did recieved. but this time do not unsync");
    
    return;
    NSArray *jsonArray;
    jsonArray = [NSJSONSerialization JSONObjectWithData:recievedData options:NSJSONReadingAllowFragments error:nil];
    NSMutableArray *railwayArray = [NSMutableArray array];
    
    for (NSDictionary *railwayDict in jsonArray) {
        Railway *railway = [[Railway alloc]initWithDictionary:railwayDict];
        [railwayArray addObject:railway];
    }

    self.allRailway = railwayArray;
    
    if ([self.delegate respondsToSelector:@selector(didUpdateRailwayInformation)]) {
        [self.delegate didUpdateRailwayInformation];
    }
}


- (void)connection:(Connection *)connection didResponseError:(NSError *)error {
    
}

- (void)connection:(Connection *)connection didSend:(NSError *)error {
    
}
#pragma mark - RailWayManager delegate

@end
