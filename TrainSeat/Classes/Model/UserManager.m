//
//  UserManager.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/01.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager
// singleton
static UserManager *shareInstance = nil;
+ (instancetype)defaultUserManager {
    
    if (!shareInstance) {
        shareInstance = [UserManager new];
    }
    return shareInstance;
}

@end
