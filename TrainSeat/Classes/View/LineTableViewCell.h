//
//  LineTableViewCell.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/14.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Train.h"

@interface LineTableViewCell : UITableViewCell

@property (nonatomic ,weak) IBOutlet UILabel *stationTitle;
@property (nonatomic ,weak) IBOutlet UIImageView *stationIcon;
@property (nonatomic ,weak) IBOutlet UIButton *trainUp;
@property (nonatomic ,weak) IBOutlet UIButton *trainDown;
@property (nonatomic ,weak) IBOutlet UILabel *arrowUp;
@property (nonatomic ,weak) IBOutlet UILabel *arrowDown;
@property (nonatomic ,weak) IBOutlet UIView *line;
@property (nonatomic) Train *train;
@end
