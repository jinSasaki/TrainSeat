//
//  TrainInfoViewController.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "TrainInfoViewController.h"

@interface TrainInfoViewController ()
{
    NSArray *timetableStrings;
}
@end

@implementation TrainInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 時刻表データを同期的に取得
    //
    self.pickerview.delegate = self;
    
    Timetable *timetable = [Timetable new];
    
    timetableStrings = [timetable loadTimetable:self.trainInfo.nearStation];
        
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"HH:mm";
    NSString *nowStr = [df stringFromDate:date];
    for (int i=0; i<timetableStrings.count; i++) {
        NSString *str1 = [timetableStrings[i] stringByReplacingOccurrencesOfString:@":" withString:@""];
        NSString *str2 = [nowStr stringByReplacingOccurrencesOfString:@":" withString:@""];
        int time = str1.intValue;
        int now = str2.intValue;
        if (now < time) {
            [self.pickerview selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
    
    TrainInfoManager *trainInfoManager = [TrainInfoManager defaultTrainInfoManager];
    TrainInfo *userTrainInfo = trainInfoManager.userTrainInfo;
    if (userTrainInfo) {
        self.statusSegment.selectedSegmentIndex = userTrainInfo.status;
        self.directionSegment.selectedSegmentIndex = userTrainInfo.direction;
    }
}


#pragma mark - pickerview delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return timetableStrings.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return timetableStrings[row];
}
-(void)selectRow:(NSInteger)row
     inComponent:(NSInteger)component
        animated:(BOOL)animated {
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    self.trainInfo.departureTime = timetableStrings[[self.pickerview selectedRowInComponent:0]];
    self.trainInfo.direction = self.directionSegment.selectedSegmentIndex;
    self.trainInfo.status = self.statusSegment.selectedSegmentIndex;
    
    
    CarInfoViewController *vc = [segue destinationViewController];
    vc.trainInfo = self.trainInfo;

    
}


@end
