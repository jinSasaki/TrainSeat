//
//  UserManager.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/01.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrainInfo.h"
#import "Connection+TokyoMetroAPI.h"

@class UserManager;

@protocol UserManagerDelegate <NSObject>

- (void)userManager:(UserManager *)manager didRecievedTrainInfos:(NSArray *)trainInfos;

@end
@interface UserManager : NSObject <ConnectionDelegate>

@property (nonatomic) TrainInfo *currentTrainInfo;
@property (nonatomic,weak) id <UserManagerDelegate> delegate;
@property (nonatomic) NSArray *trainInfos;

+ (instancetype)defaultUserManager;

- (void)requestToGET;
- (void)requestToSET;


@end