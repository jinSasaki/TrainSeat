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

@class TrainButton;

@interface TrainButton : UIButton
@property (nonatomic) Train *train;
@property (nonatomic) TrainButtonDirection direction;
@property NSTimer *flashTimer;

+ (id)buttonWithType:(UIButtonType)buttonType railWay:(Railway *)railway direction:(TrainButtonDirection)direction;
+ (id)buttonWithType:(UIButtonType)buttonType railWay:(Railway *)railway direction:(TrainButtonDirection)direction train:(Train *)train;
- (id)initWithRailway:(Railway *)railway direction:(TrainButtonDirection)direction train:(Train *)train;

@end

