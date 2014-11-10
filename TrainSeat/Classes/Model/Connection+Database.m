//
//  Connection+Database.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/06.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "Connection+Database.h"


NSString * const BASE_URL = @"path/to/url";

@implementation Connection (Database)
- (NSData *)sendGETRequestToDatabase:(id)sender {
    
    NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingPathComponent:@"get.php"]];
    [self sendRequestWithURL:url];
    return nil;
}

@end
