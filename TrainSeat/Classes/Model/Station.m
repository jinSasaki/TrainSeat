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
        
        self.order = [[self.stationCode substringFromIndex:1] intValue];
    }
    
    return self;
}
/*
 [{
 "@id": "urn:ucode:_00001C000000000000010000030C46D6",
 "@type": "odpt:Station",
 "owl:sameAs": "odpt.Station:TokyoMetro.Marunouchi.Ogikubo",
 "dc:date": "2014-10-02T22:13:50+09:00",
 "dc:title": "荻窪",
 "ug:region": "https://api.tokyometroapp.jp/api/v2/places/urn:ucode:_00001C000000000000010000030C46D6.geojson",
 "odpt:operator": "odpt.Operator:TokyoMetro",
 "odpt:railway": "odpt.Railway:TokyoMetro.Marunouchi",
 "odpt:connectingRailway": ["odpt.Railway:JR-East.ChuoKaisoku", "odpt.Railway:JR-East.ChuoSobu"],
 "odpt:facility": "odpt.StationFacility:TokyoMetro.Ogikubo",
 "odpt:passengerSurvey": ["odpt.PassengerSurvey:TokyoMetro.Ogikubo.2013", "odpt.PassengerSurvey:TokyoMetro.Ogikubo.2012", "odpt.PassengerSurvey:TokyoMetro.Ogikubo.2011"],
 "odpt:stationCode": "M01",
 "odpt:exit": ["urn:ucode:_00001C000000000000010000030C4278", "urn:ucode:_00001C000000000000010000030C4279", "urn:ucode:_00001C000000000000010000030C427A", "urn:ucode:_00001C000000000000010000030C427B", "urn:ucode:_00001C000000000000010000030C427C"],
 "@context": "http://vocab.tokyometroapp.jp/context_odpt_Station.jsonld",
 "geo:lat": 35.704175,
 "geo:long": 139.61976
 }]
*/

@end
