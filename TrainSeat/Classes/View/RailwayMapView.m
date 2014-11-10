//
//  RailwayMapView.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/07.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "RailwayMapView.h"

@implementation RailwayMapView

// 駅ボタンすべてと、駅の順番をもらって駅ボタンの間に線を描画
// 駅ボタンから座標を取得（centerで事足りそうな気がする）

- (id)initWithFrame:(CGRect)frame stationButtons:(NSArray *)buttons stationOrder:(NSArray *)order matchList:(NSDictionary *)matchList railwayColor:(UIColor *)raiwayColor {
    self.railwayColor = raiwayColor;
    self = [super initWithFrame:frame];
    if (self) {
        railwayBtnArray = [NSMutableArray array];

        for (int i=0; i<order.count; i++) {
            // 駅名と一致するボタンを検索
            if (matchList[order[i]]) {
                [railwayBtnArray addObject:buttons[[matchList[order[i]] intValue]]];
            }else {
                NSLog(@"not found %@",order[i]);
            }
        }
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    for (int i=1; i<railwayBtnArray.count; i++) {
        UIButton *btn1 = railwayBtnArray[i-1];
        UIButton *btn2 = railwayBtnArray[i];
        
        UIBezierPath *bezier = [UIBezierPath bezierPath];
        [bezier moveToPoint:btn1.center];
        [bezier addLineToPoint:btn2.center];
        [self.railwayColor setStroke];
        bezier.lineWidth = 10.0;
        [bezier stroke];
    }
}

@end