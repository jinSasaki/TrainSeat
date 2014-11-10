//
//  TrainMapViewController.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "TrainMapViewController.h"

@interface TrainMapViewController ()
{
    NSArray *railwayArray;
    NSArray *stationArray;
    NSArray *jsonArray;
    RailwayManager *manager;
}
@end

@implementation TrainMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    manager = [RailwayManager defaultManager];
    manager.delegate = self;

    UserManager *uManager = [UserManager defaultUserManager];
    TrainInfo *currentTrainInfo = uManager.currentTrainInfo;
    
    Railway *currentRailway = manager.allRailway[currentTrainInfo.railwayIndex];

    stationArray = currentRailway.stations;
    railwayArray = manager.allRailway;
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    if (currentTrainInfo) {
        [self.pickerView selectRow:currentTrainInfo.railwayIndex inComponent:0 animated:NO];
        [self.pickerView selectRow:currentTrainInfo.stationIndex inComponent:1 animated:NO];
        
    }

    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSUInteger rows;
    switch (component) {
        case 0:
            rows = railwayArray.count;
            break;

        case 1:
            rows = stationArray.count;
            break;

        default:
            rows = 0;
            break;
    }
    return rows;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    Railway *railway;
    Station *station;
    switch (component) {
        case 0:
            railway = railwayArray[row];
            title = railway.title;
            break;
            
        case 1:
            station = stationArray[row];
            title = station.title;
            break;
            
        default:
            title = @"";
            break;
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [self updateStationArray:row];
        [pickerView reloadComponent:1];
    }
}
- (void)updateStationArray:(NSUInteger)row {
    
    
    Railway *currentRailway = manager.allRailway[row];
    
    stationArray = currentRailway.stations;

}

- (void)didUpdateRailwayInformation {
    railwayArray = manager.allRailway;
    [self.pickerView reloadAllComponents];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    TrainInfo *trainInfo = [TrainInfo new];
    trainInfo.railwayIndex = [self.pickerView selectedRowInComponent:0];
    trainInfo.stationIndex = [self.pickerView selectedRowInComponent:1];
    trainInfo.dstStation = stationArray[[self.pickerView selectedRowInComponent:1]];

#warning Check todo
    // TODO: fix nearstation
    trainInfo.nearStation = stationArray[0];
    
    TrainInfoViewController *vc = [segue destinationViewController];
    vc.trainInfo = trainInfo;

}
@end
