//
//  Railway.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Railway : NSObject

// "@id": "urn:ucode:_00001C000000000000010000030C46AB",
@property NSString *ucode;

// "dc:title": "丸ノ内",
@property NSString *title;

// "owl:sameAs": "odpt.Railway:TokyoMetro.MarunouchiBranch",
@property NSString *code;

// MarunouchiBranch
@property NSString *railwayName;

@property NSArray *stations;

@property NSArray *order;

@property NSArray *travelTime;

// "odpt:lineCode": "m",
@property NSString *lineCode;

- (id) initWithDictionary:(NSDictionary *)dict;
@property UIColor *color;

@end
