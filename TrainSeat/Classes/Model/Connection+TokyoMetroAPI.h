//
//  Connection+TokyoMetroAPI.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "Connection.h"

@interface Connection (TokyoMetroAPI)

- (void)sendRequestWithOdptType:(OdptType)type;
- (void)sendRequestWithOdptType:(OdptType)type andQuery:(NSDictionary *)query;
- (NSData *)connectBySynchronousRequestWithOdptType:(OdptType)type andQuery:(NSDictionary *)query;
+ (NSURL *)createURLWithOdptType:(OdptType)type andQuery:(NSDictionary *)query;
+ (NSString *)createURLStringWithQuery:(NSDictionary *)query;

@end

