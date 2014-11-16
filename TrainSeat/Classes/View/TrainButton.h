//
//  TrainButton.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/16.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Train.h"
#import "Railway.h"
typedef NS_ENUM(NSInteger, TrainButtonDirection) {
    TrainButtonDirectionUp = 0,
    TrainButtonDirectionDown,
};

@interface TrainButton : UIButton
@property (nonatomic) Train *train;

+ (id)buttonWithType:(UIButtonType)buttonType railWay:(Railway *)railway direction:(TrainButtonDirection)direction;
@end

