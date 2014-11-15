//
//  LineButton.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/10.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "LineButton.h"

@implementation LineButton

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame railwayTitle:(NSString *)railwayTitle {
    self = [super initWithFrame:frame];
    if (self) {

        NSDictionary *lineLogoDict = @{
                                       @"銀座":@"ginza.jpg",
                                       @"丸ノ内":@"marunouchi.jpg",
                                       @"日比谷":@"hibiya.jpg",
                                       @"東西":@"touzai.jpg",
                                       @"千代田":@"chiyoda.jpg",
                                       @"有楽町":@"yurakucho.jpg",
                                       @"半蔵門":@"hanzoumon.jpg",
                                       @"南北":@"nanboku.jpg",
                                       @"副都心":@"fukutoshin.jpg"
                                       };

        [self setBackgroundImage:[UIImage imageNamed:lineLogoDict[railwayTitle]] forState:UIControlStateNormal];

        self.titleLabel.numberOfLines = 5;


    }
    return self;
}

@end
