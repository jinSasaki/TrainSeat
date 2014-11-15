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
@property (nonatomic, copy) NSString *ucode;

// "odpt:trainType": "odpt.TrainType:TokyoMetro.Local",
@property (nonatomic, copy) NSString *trainType;

// "odpt:delay": 0,
@property (nonatomic) int delay;

// "odpt:fromStation": "odpt.Station:TokyoMetro.Marunouchi.Myogadani",
@property (nonatomic, copy) NSString *fromStation;

// "odpt:toStation": "odpt.Station:TokyoMetro.Marunouchi.Korakuen",
@property (nonatomic, copy) NSString *toStation;

// "odpt:startingStation": "odpt.Station:TokyoMetro.Marunouchi.Ikebukuro",
@property (nonatomic, copy) NSString *startingStation;

// "odpt:terminalStation": "odpt.Station:TokyoMetro.Marunouchi.Ogikubo",
@property (nonatomic, copy) NSString *terminalStation;

// "odpt:railDirection": "odpt.RailDirection:TokyoMetro.Ogikubo",
@property (nonatomic, copy) NSString * railDirection;
// Ogikubo,
@property (nonatomic, copy) NSString * railDirectionOnlyName;

@property (nonatomic) BOOL isStop;

@property (nonatomic) CGPoint center;

@property (nonatomic) BOOL isSelected;



- (id) initWithDictionary:(NSDictionary *)dict;

@end
