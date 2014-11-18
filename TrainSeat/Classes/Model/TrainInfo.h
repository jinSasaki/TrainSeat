//
//  TrainInfo.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Station.h"
#import "Train.h"
@interface TrainInfo : NSObject


@property (nonatomic) NSString *trainCode;
// station Name ex) Ogikubo
@property (nonatomic) NSString *destination;
@property (nonatomic) int carNumber;
@property (nonatomic) int status;           // 0 -> standing 1 -> sitting
@property (nonatomic) int position;

- (id)initWithDict:(NSDictionary *)dict;

@end

