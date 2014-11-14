//
//  RailwayManager.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "RailwayManager.h"

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
    
    
    // すべての駅を取得
    NSMutableArray *stationArray = [NSMutableArray array];
    NSMutableDictionary *__allstationDict = [NSMutableDictionary dictionary];
    
    data = [connection connectBySynchronousRequestWithOdptType:OdptStation andQuery:nil];
    jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

    for (NSDictionary *stationDict in jsonArray) {
        Station *station = [[Station alloc]initWithDictionary:stationDict];
        [stationArray addObject:station];
        [__allstationDict setObject:station forKey:station.stationName];
    }
    
    self.allStationDict = __allstationDict;
    self.allStation = stationArray;
    
    
    // すべての路線を取得
    NSMutableArray *railwayArray = [NSMutableArray array];
    NSMutableDictionary *railwayDictionay = [NSMutableDictionary dictionary];
    data = [connection connectBySynchronousRequestWithOdptType:OdptRailway andQuery:nil];
    jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

    // Railwayインスタンスをセット
    for (NSDictionary *railwayDict in jsonArray) {
        Railway *railway = [[Railway alloc]initWithDictionary:railwayDict];
        
        // 路線に一致する駅のみ抽出
        NSMutableArray *array = [NSMutableArray array];
        for (Station *station in stationArray) {
            if ([railway.code compare:station.railwayCode] == NSOrderedSame) {
                [array addObject:station];
            }
        }
        railway.stations = array;

        [railwayArray addObject:railway];
        [railwayDictionay setObject:railway forKey:railway.railwayName];


    }
    
    self.allRailway = railwayArray;
    self.allRailwayDict = railwayDictionay;
    
    if ([self.delegate respondsToSelector:@selector(didUpdateRailwayInformation)]) {
        [self.delegate didUpdateRailwayInformation];
    }
}

// APIを叩いて路線・駅情報を最新版に更新する
- (void)updateRailwayInfomation {
    Connection *connection = [Connection new];
    [connection sendRequestWithOdptType:OdptRailway];
    connection.delegate = self;
}

- (NSString *)stationTitleWithStationName:(NSString *)staitonName {
    for (Station *station in self.allStation) {
        if ([station.stationName compare:staitonName] == NSOrderedSame) {
            return station.title;
        }
    }
    LOG(@"stationTitle not found.");
    return @"";
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
