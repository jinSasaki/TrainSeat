//
//  LineButton.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/10.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineButton : UIButton
@property (nonatomic) NSString *railwayName;
- (id)initWithFrame:(CGRect)frame railwayTitle:(NSString *)railwayTitle;

@end
