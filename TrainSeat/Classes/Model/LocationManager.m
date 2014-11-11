//
//  LocationManager.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/11.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

// singleton
static LocationManager *shareInstance = nil;
+ (instancetype)defaultManager {
    
    if (!shareInstance) {
        shareInstance = [LocationManager new];
    }
    return shareInstance;
}

- (void)startConnectionWithRailway:(Railway *)railway {
    [self stopConnection];
    self.currentRailway = railway;
    timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(connection) userInfo:nil repeats:YES];
    [self connection];
    NSLog(@"connection started");
}

- (void)connection {
    if (!self.currentRailway) return;
    Connection *connection = [Connection new];
    connection.delegate = self;
    NSDictionary *query = @{ StringWithParameter(ParameterRailway):self.currentRailway.code};
    [connection sendRequestWithOdptType:OdptTrain andQuery:query];

}

- (void)stopConnection {
    self.currentRailway = nil;
    [timer invalidate];
    NSLog(@"connection stopped");
}


#pragma mark - connection delegate
- (void)connection:(Connection *)connection didConnectionError:(NSError *)error {
    
}
-(void)connection:(Connection *)connection didRecieve:(NSData *)recievedData {
    RailwayManager *manager = [RailwayManager defaultManager];
    NSArray *jsonArray;
    jsonArray = [NSJSONSerialization JSONObjectWithData:recievedData options:NSJSONReadingAllowFragments error:nil];
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dict in jsonArray) {
        Train *train = [[Train alloc]initWithDictionary:dict];
        if (train.isStop) {
            Station *station = manager.allStationDict[train.fromStation];
            train.center = CGPointMake(station.center.x, station.center.y +20);
        }else {
        
            Station *fromStation = manager.allStationDict[train.fromStation];
            Station *toStation = manager.allStationDict[train.toStation];
            train.center = CGPointMake((fromStation.center.x + toStation.center.x)/2, (fromStation.center.y + toStation.center.y)/2);
        }
        
        [array addObject:train];
        NSLog(@"%@",train.fromStation);
    }
    self.trainArray = array;

    [self.delegate didRecieve];
}
-(void)connection:(Connection *)connection didResponseError:(NSError *)error {
    
}
-(void)connection:(Connection *)connection didSend:(NSError *)error {
    
}

@end
