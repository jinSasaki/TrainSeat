//
//  TrainInfo.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "TrainInfo.h"

@implementation TrainInfo
- (id)initWithDict:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.trainCode = [dict objectForKey:@"train_code"];
        self.destination = [dict objectForKey:@"destination"];
        self.carNumber = [[dict objectForKey:@"car_number"] intValue];
        self.status = [[dict objectForKey:@"status"] intValue];
        self.position = [[dict objectForKey:@"position"]intValue];
    }
    return self;
}

@end

