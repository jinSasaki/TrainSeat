//
//  TrainInfoManager.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/16.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "TrainInfoManager.h"

@implementation TrainInfoManager
// singleton
static TrainInfoManager *shareInstance = nil;
+ (instancetype)defaultTrainInfoManager {
    
    if (!shareInstance) {
        shareInstance = [TrainInfoManager new];
    }
    return shareInstance;
}
- (void)requestToGET {
    Connection *connection = [Connection new];
    connection.delegate = self;
    NSDictionary *paramDict = @{@"train_code": self.userTrainInfo.trainCode,};
    NSString *paramQuery = [Connection createURLStringWithQuery:paramDict];
    NSString * urlStr = [API_IP_ADDRESS stringByAppendingString:@"api/get?"];
    urlStr = [urlStr stringByAppendingString:paramQuery];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    connection.identifer = @"get";
    [connection sendRequestWithURL:url];
    LOG(@"%@",urlStr);
    
}
- (void)requestToSET {
    Connection *connection = [Connection new];
    connection.delegate = self;
    NSDictionary *paramDict = @{@"train_code": self.userTrainInfo.trainCode,
                                @"destination":self.userTrainInfo.destination,
                                @"car_number":[NSString stringWithFormat:@"%d",self.userTrainInfo.carNumber],
                                @"status":[NSString stringWithFormat:@"%ld",self.userTrainInfo.status],
                                @"position":[NSString stringWithFormat:@"%d",self.userTrainInfo.position]};
    NSString *paramQuery = [Connection createURLStringWithQuery:paramDict];
    NSString * urlStr = [API_IP_ADDRESS stringByAppendingString:@"api/set?"];
    urlStr = [urlStr stringByAppendingString:paramQuery];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    connection.identifer = @"set";
    [connection sendRequestWithURL:url];
    
}


- (void)connection:(Connection *)connection didConnectionError:(NSError *)error {
    LOG_METHOD;
    LOG_PRINTF(@"%@",error);
}

- (void)connection:(Connection *)connection didRecieve:(NSData *)recievedData {
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:recievedData options:NSJSONReadingAllowFragments error:nil];
    if ([connection.identifer isEqualToString: @"set"]) {
        if ([responseJSON objectForKey:@"isSuccess"]) {
            LOG_PRINTF(@"success");
        }else {
            LOG_PRINTF(@"failed");
        }
    }else if ([connection.identifer isEqualToString:@"get"]) {
        // 一覧情報をパース
        NSMutableArray *trainInfoArray = [NSMutableArray array];
        
        if ([responseJSON objectForKey:@"isSuccess"]) {
            LOG_PRINTF(@"success");
            NSArray *dataArray = [responseJSON objectForKey:@"data"];
            for (NSDictionary *data in dataArray) {
                TrainInfo *trainInfo = [[TrainInfo alloc]initWithDict:data];
                [trainInfoArray addObject:trainInfo];
            }
            self.trainInfos = trainInfoArray;
            [self.delegate trainInfoManager:self didRecievedTrainInfos:self.trainInfos];
        }else {
        }
        
    }
    
    
}
- (void)connection:(Connection *)connection didResponseError:(NSError *)error {
    LOG_METHOD;
    LOG_PRINTF(@"%@",error);
    
}

- (void)connection:(Connection *)connection didSend:(NSError *)error {
    LOG_METHOD;
    LOG_PRINTF(@"%@",error);
    
}


@end
