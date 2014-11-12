//
//  StationButton.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/11.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Station.h"

@interface StationButton : UIButton

@property (nonatomic , weak) Station *staion;
+ (id)buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame station:(Station *)station;
@end
