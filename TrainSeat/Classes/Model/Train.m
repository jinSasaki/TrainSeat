//
//  Train.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/11.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "Train.h"

@implementation Train
- (id) initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        
        self.ucode = [dict objectForKey:@"@id"];
        self.trainType = [dict objectForKey:@"odpt:trainType"];
        self.delay = [[dict objectForKey:@"odpt:delay"] intValue];
        self.fromStation = [dict objectForKey:@"odpt:fromStation"];
        self.toStation = [dict objectForKey:@"odpt:toStation"];

        self.fromStationTrimed = [self trimString:[dict objectForKey:@"odpt:fromStation"]];
        self.toStationTrimed = [self trimString:[dict objectForKey:@"odpt:toStation"]];

        self.startingStation = [dict objectForKey:@"odpt:startingStation"];
        self.terminalStation = [dict objectForKey:@"odpt:terminalStation"];

        self.railDirection = [dict objectForKey:@"odpt:railDirection"];
        self.railDirectionOnlyName = [self trimString:[dict objectForKey:@"odpt:railDirection"]];
        
        
        if (![self trimString:self.toStation]) {
            self.isStop = YES;
        }else {
            self.isStop = NO;
        }
        
        
    }
    return self;
}



- (NSString *)trimString:(NSString *)string {
    if ( [string isEqual:[NSNull null]]) {
        return nil;
    }

    NSRange searchResult = [string rangeOfString:@"."];
    if(searchResult.location == NSNotFound ){
        return nil;
    }

    NSArray *strs = [string componentsSeparatedByString:@"."];
    return strs[strs.count-1];
    
}

@end
