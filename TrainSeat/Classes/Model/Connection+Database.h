//
//  Connection+Database.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/06.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "Connection.h"


@interface Connection (Database)


- (void)sendRequestWtihPrarmeters:(NSDictionary *)params;



@end


