//
//  TimeTable.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/06.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Station.h"
#import "Connection+TokyoMetroAPI.h"
#import "TrainInfoManager.h"

@interface Timetable : NSObject

@property (nonatomic, copy) NSArray *tables;

- (NSArray *)loadTimetable:(Station *)station;

@end
