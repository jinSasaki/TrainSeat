//
//  TrainInfo.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Station.h"
#import "Train.h"
@interface TrainInfo : NSObject


@property (nonatomic) NSString *trainCode;
@property (nonatomic) NSString *destination;
@property (nonatomic) int carNumber;
@property (nonatomic) BOOL isSittng;
@property (nonatomic) int position;


//--------------------------------------------------------------------------------
// イラネ
// TODO: delete

// 次に電車が到着する駅
@property (nonatomic) Station *nearStation;

// 到着予定駅
@property (nonatomic) Station *dstStation;

// 路線のID ID管理するか、クラス管理するかはまた別途考える
@property (nonatomic) NSInteger railwayIndex;
@property (nonatomic) NSInteger stationIndex;

// 電車の進行方向（主に座ってる人の位置を考えるためのもの）
@property (nonatomic) NSInteger direction;

// 乗車状態 立ち・座りの２値
@property (nonatomic) NSInteger status;

// 乗車中の電車の発車時刻
@property (nonatomic, copy) NSString *departureTime;

// 乗車車両目
//@property (nonatomic) NSInteger carNumber;

// 車両内の乗車位置
@property (nonatomic) NSInteger locationInCar;

// 混雑状況
@property (nonatomic) NSInteger crowdedness;

// 車内温度（目安を段階で）
@property (nonatomic) NSInteger temperature;

// 乗車中の電車
@property (nonatomic) Train *ridingTrain;

- (id)initWithDict:(NSDictionary *)dict;

@end

