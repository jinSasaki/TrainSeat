//
//  Railway.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "Railway.h"

@implementation Railway
- (id) initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.ucode = [dict objectForKey:@"@id"];
        self.title = [dict objectForKey:@"dc:title"];
        
        self.lineCode = [dict objectForKey:@"odpt:lineCode"];
        self.travelTime = [dict objectForKey:@"odpt:travelTime"];
        
        self.code = [dict objectForKey:@"owl:sameAs"];
        
        // railwayName
        NSArray *codes = [self.code componentsSeparatedByString:@"."];
        self.railwayName = codes[codes.count-1];
        
        
        // order作成
        NSArray *orderArray =[dict objectForKey:@"odpt:stationOrder"];
        NSMutableArray *mArray = [NSMutableArray array];
        for (int i=0; i<orderArray.count; i++) {
            NSString *orderStr = [orderArray[i] objectForKey:@"odpt:station"];
            [mArray addObject:orderStr];
        }
        self.order = mArray;
        self.color = [self createColorWithTitle:self.title];
        
    }
    return self;
}

- (UIColor *)createColorWithTitle :(NSString *)title {
    NSDictionary *lineColorDict =
    @{
      @"銀座":@"243,151,0",
      @"丸ノ内":@"230,0,18",
      @"日比谷":@"156,174,183",
      @"東西":@"0,167,219",
      @"千代田":@"0,153,68",
      @"有楽町":@"215,196,71",
      @"半蔵門":@"155,124,182",
      @"南北":@"0,173,169",
      @"副都心":@"187,100,29"
      };
    
    NSString *rgbParam = lineColorDict[title];
    return [self createUIColorWithRGBParameter:rgbParam];
    
    
}

- (UIColor *)createUIColorWithRGBParameter:(NSString *)parameter {
    NSArray *param = [parameter componentsSeparatedByString:@","];
    return [UIColor colorWithRed:[param[0] doubleValue]/256 green:[param[1] doubleValue]/256 blue:[param[2] doubleValue]/256 alpha:1.0];
    
}

@end
