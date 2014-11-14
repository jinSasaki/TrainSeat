//
//  LineTableViewCell.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/14.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineTableViewCell : UITableViewCell

@property (nonatomic ,weak) IBOutlet UILabel *stationTitle;
@property (nonatomic ,weak) IBOutlet UILabel *stationIcon;
@property (nonatomic ,weak) IBOutlet UIImageView *trainUp;
@property (nonatomic ,weak) IBOutlet UIImageView *trainDown;
@property (nonatomic ,weak) IBOutlet UILabel *arrowUp;
@property (nonatomic ,weak) IBOutlet UILabel *arrowDown;
@property (nonatomic ,weak) IBOutlet UIView *line;
@end
