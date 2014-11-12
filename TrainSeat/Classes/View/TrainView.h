//
//  TrainView.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/11.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Train.h"

@interface TrainView : UIView

@property (nonatomic , weak) UIButton *trainIcon;

@property (nonatomic , weak) UILabel *alertDelay;

@property (nonatomic) BOOL isRunning;

@property (nonatomic , weak) Train *train;

- (id)initWithFrame:(CGRect)frame train:(Train *)train;

- (void)hideWithDirection:(NSString *)direction;

@end
