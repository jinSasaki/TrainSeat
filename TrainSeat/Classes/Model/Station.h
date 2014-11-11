//
//  Station.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Station : NSObject

// "@id": "urn:ucode:_00001C000000000000010000030C46C1",
@property NSString *ucode;

@property NSString *sameAs;

// "dc:title": "飯田橋",
@property NSString *title;

// "odpt:railway": "odpt.Railway:TokyoMetro.Yurakucho",
@property NSString *railwayCode;

// Iidabashi
@property NSString *stationName;

// "odpt:stationCode": "Y13",
@property NSString *stationCode;

// "geo:lat": 35.7013417869126,
// "geo:long": 139.743207437669
@property CLLocation *location;

@property CGPoint center;
- (id) initWithDictionary:(NSDictionary *)dict;

@end
