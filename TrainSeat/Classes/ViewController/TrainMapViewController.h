//
//  TrainMapViewController.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RailwayManager.h"
#import "TrainInfoViewController.h"
#import "TrainInfo.h"
#import "TrainInfoManager.h"

@interface TrainMapViewController : UIViewController
<UIPickerViewDelegate,UIPickerViewDataSource , RailwayManagerDelegate>


@property IBOutlet UIPickerView *pickerView;

@end
