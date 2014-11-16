//
//  TrainInfoManager.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/16.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrainInfo.h"
#import "Connection+TokyoMetroAPI.h"

@class TrainInfoManager;

@protocol TrainInfoManagerDelegate <NSObject>

- (void)trainInfoManager:(TrainInfoManager *)manager didRecievedTrainInfos:(NSArray *)trainInfos;

@end

@interface TrainInfoManager : NSObject <ConnectionDelegate>

@property (nonatomic) TrainInfo *userTrainInfo;
@property (nonatomic,weak) id <TrainInfoManagerDelegate> delegate;
@property (nonatomic) NSArray *trainInfos;
@property (nonatomic) NSDictionary *trainInfoForView;

+ (instancetype)defaultTrainInfoManager;

- (void)requestToGET;
- (void)requestToSET;

@end
