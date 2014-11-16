//
//  TrainButton.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/16.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "TrainButton.h"

@implementation TrainButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id)buttonWithType:(UIButtonType)buttonType railWay:(Railway *)railway direction:(TrainButtonDirection)direction {
    TrainButton *instance = [super buttonWithType:buttonType];
    NSString *imageName;
    CGPoint center;
    instance.frame = CGRectMake(0, 0, 30, 45);

    switch (direction) {
        case TrainButtonDirectionUp:
            // 上
            imageName =[NSString stringWithFormat:@"%@_train_1",[railway.railwayName lowercaseString]];
            
            center = CGPointMake(100, 30);
            break;
        case TrainButtonDirectionDown:
            // 下
            imageName =[NSString stringWithFormat:@"%@_train_2",[railway.railwayName lowercaseString]];
            center = CGPointMake(220, 30);
            break;
            
        default:
            imageName = nil;
            center = CGPointZero;
            break;
    }
    instance.center = center;
    [instance setBackgroundImage:
     [UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return instance;
}

@end
