//
//  Train.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/11.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Train : NSObject

// "@id": "urn:ucode:_00001C000000000000010000030CA13E",
@property (nonatomic , weak) NSString *ucode;

// "odpt:trainType": "odpt.TrainType:TokyoMetro.Local",
@property (nonatomic , weak) NSString *trainType;

// "odpt:delay": 0,
@property (nonatomic) int delay;

// "odpt:fromStation": "odpt.Station:TokyoMetro.Marunouchi.Myogadani",
@property (nonatomic , weak) NSString *fromStation;

// "odpt:toStation": "odpt.Station:TokyoMetro.Marunouchi.Korakuen",
@property (nonatomic , weak) NSString *toStation;

// "odpt:startingStation": "odpt.Station:TokyoMetro.Marunouchi.Ikebukuro",
@property (nonatomic , weak) NSString *startingStaion;

// "odpt:terminalStation": "odpt.Station:TokyoMetro.Marunouchi.Ogikubo",
@property (nonatomic , weak) NSString *terminalStation;

// "odpt:railDirection": "odpt.RailDirection:TokyoMetro.Ogikubo",
@property (nonatomic , weak) NSString * railDirection;

@property (nonatomic) BOOL isStop;

@property (nonatomic) CGPoint center;

@property (nonatomic) double angle;

- (id) initWithDictionary:(NSDictionary *)dict;

@end
