//
//  Station.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "Station.h"

@implementation Station
- (id) initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.ucode = [dict objectForKey:@"@id"];
        self.title = [dict objectForKey:@"dc:title"];
        self.sameAs = [dict objectForKey:@"owl:sameAs"];
        self.railwayCode = [dict objectForKey:@"odpt:railway"];
        self.stationCode = [dict objectForKey:@"odpt:stationCode"];
        double latitude = [[dict objectForKey:@"geo:lat"] doubleValue];
        double longitude = [[dict objectForKey:@"geo:long"] doubleValue];
        CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
        self.location = location;
        
        NSArray *codes = [self.sameAs componentsSeparatedByString:@"."];
        self.stationName = codes[codes.count-1];

    }
    
    return self;
}


@end
