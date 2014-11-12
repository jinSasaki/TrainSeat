//
//  TrainView.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/11.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "TrainView.h"

@implementation TrainView


const double height = 30;
const double width = 50;
- (id)initWithFrame:(CGRect)frame train:(Train *)train
{
    self = [super initWithFrame:frame];
    if (self) {
        self.train = train;
        NSDictionary *iconDict = @{
                                   @"銀座":@"ginza.png",
                                   @"丸ノ内":@"marunouchi.png",
                                   @"日比谷":@"hibiya.png",
                                   @"東西":@"touzai.png",
                                   @"千代田":@"chiyoda.png",
                                   @"有楽町":@"yurakucho.png",
                                   @"半蔵門":@"hanzoumon.png",
                                   @"南北":@"nanboku.png",
                                   @"副都心":@"fukutoshin.png"
                                   };
        
        self.trainIcon = [UIButton buttonWithType:UIButtonTypeSystem];
        self.trainIcon.frame = CGRectMake(0, 0, width, height);
        [self.trainIcon addTarget:self action:@selector(trainIconDidPush:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.trainIcon];
    
        #warning this is test case
        [self.trainIcon setBackgroundImage:[UIImage imageNamed:iconDict[@"銀座"]] forState:UIControlStateNormal];
        
        if (train.delay) {
            self.alertDelay = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.origin.y - 20, width, height)];
            self.alertDelay.text = [NSString stringWithFormat:@"%d",train.delay];
            self.alertDelay.textColor = [UIColor redColor];
            [self addSubview:self.alertDelay];
        }
        if (!train.isStop) {
            self.isRunning = YES;
            self.alpha = 0.3;
            [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(flash:) userInfo:nil repeats:YES];
        }
        
    }
    return self;
}

- (void)flash:(NSTimer *)timer {
    if (!self.isRunning) {
        [timer invalidate];
        return;
    }
    if (self.alpha > 0.5) {
        self.alpha = 0.5;
    }else {
        self.alpha = 1.0;
    }
}

- (void)hideWithDirection:(NSString *)direction {
    if ([direction compare:self.train.railDirection] == NSOrderedSame) {
        self.hidden = NO;
    }else {
        self.hidden = YES;
    }
}

- (void)trainIconDidPush:(id)sender {
    LOG_METHOD;
    UIButton *trainIcon = sender;
    TrainView *superView = (TrainView *)trainIcon.superview;
    LOG(@"%@",superView.train.railDirection);
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
