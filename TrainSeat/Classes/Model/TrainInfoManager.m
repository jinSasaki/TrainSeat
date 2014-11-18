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
                                @"status":[NSString stringWithFormat:@"%d",self.userTrainInfo.status],
                                @"position":[NSString stringWithFormat:@"%d",self.userTrainInfo.position]};
    NSString *paramQuery = [Connection createURLStringWithQuery:paramDict];
    NSString * urlStr = [API_IP_ADDRESS stringByAppendingString:@"api/set?"];
    urlStr = [urlStr stringByAppendingString:paramQuery];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    connection.identifer = @"set";
    [connection sendRequestWithURL:url];
    
}

- (void)startConnectionWtihTimeInterval:(NSTimeInterval)timeInterval {
    [self requestToGET];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(requestToGET) userInfo:nil repeats:YES];
}
- (void)stopConnection {
    [self.timer invalidate];
}


- (void)createDictionaryForView {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (TrainInfo *trainInfo in self.trainInfos) {
        NSMutableDictionary *cars;
        NSMutableArray *positions = [NSMutableArray array];;
        NSInteger offPeople = 0;
        
        // 駅が登録されてたら
        if ([dict objectForKey:trainInfo.destination]) {
            cars = [NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:trainInfo.destination]];
            
            // 車両が登録されてたら
            if ([cars objectForKey:stringFromInteger(trainInfo.carNumber)]) {
                positions = [NSMutableArray arrayWithArray:[cars objectForKey:stringFromInteger(trainInfo.carNumber)]];
                
                // 座ってたらポジション追加
                if (trainInfo.status){
                    [positions addObject:stringFromInteger(trainInfo.position)];
                }
                offPeople++;
                [cars setObject:positions forKey:stringFromInteger(trainInfo.carNumber)];
            }
            
            // 車両が登録されてなかったら車両をキーにポジション配列を追加
            else {
                [cars setObject:@[stringFromInteger(trainInfo.position)] forKey:stringFromInteger(trainInfo.carNumber)];
            }
            [dict setObject:cars forKey:trainInfo.destination];
        }
        
        // 駅が登録されてなかったら、駅をキーに、車両がキーのポジション配列を追加した辞書を追加
        else {
            NSArray *positions = @[];
            // 座ってたらポジション追加
            if (trainInfo.status){
                positions = @[stringFromInteger(trainInfo.position)];
            }
            [dict setObject:@{stringFromInteger(trainInfo.carNumber): positions} forKey:trainInfo.destination];
            offPeople++;
            
        }
    }
    
    
    self.trainInfoForView = dict;
}


#pragma mark - connection delegate

- (void)connection:(Connection *)connection didConnectionError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(trainInfoManager:didRecievedError:)]) {
        [self.delegate trainInfoManager:self didRecievedError:error];
    }
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
            [self createDictionaryForView];
            [self.delegate trainInfoManager:self didRecievedTrainInfos:self.trainInfos];
        }else {
            
        }
    }
    
}

- (void)connection:(Connection *)connection didResponseError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(trainInfoManager:didRecievedError:)]) {
        [self.delegate trainInfoManager:self didRecievedError:error];
    }
}

- (void)connection:(Connection *)connection didSend:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(trainInfoManager:didRecievedError:)]) {
        [self.delegate trainInfoManager:self didRecievedError:error];
    }
    
}


@end
