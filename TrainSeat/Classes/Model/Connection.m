//
//  Connection.m
//  Location
//
//  Created by Jin Sasaki on 2014/10/17.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "Connection.h"

@implementation Connection

static NSURLConnection *connection;
static NSMutableData *async_data;
static NSString *data_str;

- (void)sendRequestWithURL:(NSURL *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection==nil) {
        // return error
        if ([self.delegate respondsToSelector:@selector(connection:didConnectionError:)]) {
            [self.delegate connection:self didConnectionError:nil];
        }
    }
    if ([self.delegate respondsToSelector:@selector(connection:didSend:)]) {
        [self.delegate connection:self didSend:nil];
    }
}



// 非同期通信 ヘッダーが返ってきた
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	// データを初期化
	async_data = [[NSMutableData alloc] initWithData:0];
}

// 非同期通信 ダウンロード中
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	// データを追加する
	[async_data appendData:data];
}

// 非同期通信 エラー
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // requst error
    if ([self.delegate respondsToSelector:@selector(connection:didResponseError:)]) {
        [self.delegate connection:self didResponseError:error];
    }
}

// 非同期通信 ダウンロード完了
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	int enc_arr[] = {
		NSUTF8StringEncoding,			// UTF-8
		NSShiftJISStringEncoding,		// Shift_JIS
		NSJapaneseEUCStringEncoding,	// EUC-JP
		NSISO2022JPStringEncoding,		// JIS
		NSUnicodeStringEncoding,		// Unicode
		NSASCIIStringEncoding			// ASCII
	};
    data_str = nil;
	
	int max = sizeof(enc_arr) / sizeof(enc_arr[0]);
	for (int i=0; i<max; i++) {
		data_str = [[NSString alloc] initWithData:async_data encoding:enc_arr[i]];
		if (data_str!=nil) {
			break;
		}
	}
    
    [data_str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    // JSON 文字列をそのまま NSJSONSerialization に渡せないので、
    // NSData に変換する
    NSData *jsonData = [data_str dataUsingEncoding:NSUnicodeStringEncoding];
    
    if ([self.delegate respondsToSelector:@selector(connection:didRecieve:)]) {
        [self.delegate connection:self didRecieve:jsonData];
    }
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    // ここにバックグラウンド処理
    NSLog(@"background");
}


@end
