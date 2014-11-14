//
//  TrainView.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/11.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Train.h"
#import "Railway.h"

@interface TrainView : UIView

@property (nonatomic) UIButton *trainIcon;

@property (nonatomic) UILabel *alertDelay;

@property (nonatomic) BOOL isRunning;

@property (nonatomic) Train *train;

@property (nonatomic) BOOL isSelected;

- (id)initWithFrame:(CGRect)frame train:(Train *)train railway:(Railway *)railway trainDidSelectSelector:(SEL)selector;

- (void)hideWithDirection:(NSString *)direction;

@end
