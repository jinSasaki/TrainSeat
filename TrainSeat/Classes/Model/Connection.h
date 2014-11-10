//
//  Connection.h
//  Location
//
//  Created by Jin Sasaki on 2014/10/17.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Connection;

@protocol ConnectionDelegate <NSObject>

- (void)connection:(Connection *)connection didSend:(NSError *)error;
- (void)connection:(Connection *)connection didRecieve:(NSData *)recievedData;
- (void)connection:(Connection *)connection didConnectionError:(NSError *)error;
- (void)connection:(Connection *)connection didResponseError:(NSError *)error;

@end

@interface Connection : NSObject

@property id <ConnectionDelegate> delegate;

- (void)sendRequestWithURL:(NSURL *)url;



@end
