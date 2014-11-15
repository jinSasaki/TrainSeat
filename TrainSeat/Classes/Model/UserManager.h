//
//  UserManager.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/01.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrainInfo.h"

@interface UserManager : NSObject

@property (nonatomic) TrainInfo *currentTrainInfo;

+ (instancetype)defaultUserManager;

@end
