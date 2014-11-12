//
//  StationButton.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/11.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "StationButton.h"

@implementation StationButton

const double minHeight = 20;
const double minWidth = 30;

+ (id)buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame station:(Station *)station {
    StationButton *instance = [super buttonWithType:buttonType];
    
    if (frame.size.height < minHeight) {
        frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, minHeight);
    }
    if (frame.size.width < minWidth) {
        frame = CGRectMake(frame.origin.x, frame.origin.y, minWidth, frame.size.height);
    }
    
    instance.frame = frame;
    instance.staion = station;
    instance.titleLabel.adjustsFontSizeToFitWidth = YES;
    instance.titleLabel.minimumFontSize = 9.0;
    instance.titleLabel.textColor = [UIColor blackColor];
    instance.titleLabel.numberOfLines = 5;
    instance.backgroundColor = [UIColor whiteColor];
    
    instance.layer.borderColor = [[UIColor blackColor]CGColor];
    instance.layer.borderWidth = 1.0;
    
    instance.layer.cornerRadius = 5.0;
    [instance addTarget:instance action:@selector(didPush:) forControlEvents:UIControlEventTouchUpInside];

    return instance;
    
}


- (void)didPush:(id)sender {
    StationButton *btn = sender;
    
    LOG(@"pushed %@",btn.currentTitle);
}


@end
