//
//  TimeTable.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/06.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "Timetable.h"

@implementation Timetable

- (NSArray *)loadTimetable:(Station *)station {
    Connection *connection = [Connection new];

    // クエリを指定
    NSDictionary *query = @{StringWithParameter(ParameterStation): station.sameAs};
    
    NSData *data = [connection connectBySynchronousRequestWithOdptType:OdptStationTimeTable andQuery:query];
    
    // 一旦パース
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    LOG(@"%@",error);
    
    NSMutableArray *arrayStrings = [NSMutableArray array];
    for (NSDictionary *dict in jsonArray) {
        if ([dict objectForKey:@"odpt:weekdays"]) {
            NSArray *objectArray = [dict objectForKey:@"odpt:weekdays"];
            for (NSDictionary *object in objectArray) {
                [arrayStrings addObject:[object objectForKey:@"odpt:departureTime"]];
            }
        }
    }
    
    self.tables = arrayStrings;

    return self.tables;
}
@end
