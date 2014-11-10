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
                                       @"銀座":@"lineLogo_ginza.png",
                                       @"丸ノ内":@"lineLogo_marunouchi.png",
                                       @"日比谷":@"lineLogo_hibiya.png",
                                       @"東西":@"lineLogo_touzai.png",
                                       @"千代田":@"lineLogo_chiyoda.png",
                                       @"有楽町":@"lineLogo_yurakucho.png",
                                       @"半蔵門":@"lineLogo_hanzoumon.png",
                                       @"南北":@"lineLogo_nanboku.png",
                                       @"副都心":@"lineLogo_fukutoshin.png"
                                       };

        [self setBackgroundImage:[UIImage imageNamed:lineLogoDict[railwayTitle]] forState:UIControlStateNormal];

        self.titleLabel.numberOfLines = 5;


    }
    return self;
}

@end
