//
//  PassengerViewController.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/16.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "PassengerViewController.h"

@interface PassengerViewController ()
{
    double startedScrollContentOffsetX;
    NSTimer *timer;
}
@end
@implementation PassengerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trainInfoManager = [TrainInfoManager defaultTrainInfoManager];
    self.trainInfoManager.delegate = self;
    
    self.railwayManager = [RailwayManager defaultManager];

    self.locationManager = [LocationManager defaultManager];
    
//#warning this is test
//    Railway *railway = self.railwayManager.allRailway[6];
    Railway *railway = self.railwayManager.userRailway;
    
    
    /**
     * initialize station scroll view
     */

    double scWidth = 320;
    double scHeight = self.stationScrollView.frame.size.height;
    double margin = 80;
    
    self.stationScrollView.delegate = self;
    
    // set scroll content size
    self.stationScrollView.contentSize = CGSizeMake(scWidth * railway.stationArray.count, scHeight);

    
    
    double lineWidth = 30;
    double iconSize = 30;
    double lineMargin = 50;
    
    double subLabelWidth = 100;
    double subLabelMargin = 80;
    
    
    // each station on this railway
    for (int i=0; i<railway.stationArray.count; i++) {
        
        // set Line Color View
        UIView *lineColorView = [[UIView alloc]initWithFrame:CGRectMake(0, scHeight - lineWidth, scWidth - lineMargin , lineWidth)];
        lineColorView.center = CGPointMake(scWidth * i + scWidth / 2, lineColorView.center.y);
        lineColorView.backgroundColor = railway.color;
        [self.stationScrollView addSubview:lineColorView];
        
        Station *station = railway.stationArray[i];

        // set Station Title Label
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, scWidth - margin, scHeight - margin)];
        label.text = station.title;
        label.textAlignment = UITextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:30.0];
        label.center = CGPointMake( scWidth * i + scWidth / 2, scHeight / 2);
        [self.stationScrollView addSubview:label];

        if (i > 0) {
            Station *subStation = railway.stationArray[i-1];
            // set Station Title Label
            UILabel *subLabel = [[UILabel alloc]initWithFrame:CGRectMake( lineMargin + scWidth * i , scHeight - lineWidth, subLabelWidth  , lineWidth)];
            subLabel.text = subStation.title;
            subLabel.textAlignment = UITextAlignmentCenter;
            subLabel.font = [UIFont systemFontOfSize:12];
            subLabel.center = CGPointMake( subLabelMargin + scWidth * i , lineColorView.center.y);
            subLabel.textColor = [UIColor whiteColor];
            [self.stationScrollView addSubview:subLabel];
        }
        if (i < railway.stationArray.count - 1) {
            Station *subStation = railway.stationArray[i+1];
            // set Station Title Label
            UILabel *subLabel = [[UILabel alloc]initWithFrame:CGRectMake( scWidth - lineMargin + scWidth * i , scHeight - lineWidth, subLabelWidth  , lineWidth)];
            subLabel.text = subStation.title;
            subLabel.textAlignment = UITextAlignmentCenter;
            subLabel.font = [UIFont systemFontOfSize:12];
            subLabel.center = CGPointMake( scWidth - subLabelMargin + scWidth * i , lineColorView.center.y);
            subLabel.textColor = [UIColor whiteColor];
            [self.stationScrollView addSubview:subLabel];
        }



        // set Station Icon View
        UIImageView *stationIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iconSize, iconSize)];
        stationIcon.image = [UIImage imageNamed:station.stationCode];
        stationIcon.center = CGPointMake(scWidth * i + scWidth / 2, scHeight - iconSize/2);
        [self.stationScrollView addSubview:stationIcon];
        
        UIView *cardView = [[UIView alloc]initWithFrame:CGRectMake(0,lineMargin / 2, scWidth - lineMargin , scHeight - lineMargin/2)];
        cardView.center = CGPointMake(scWidth * i + scWidth / 2, cardView.center.y);
        cardView.backgroundColor = [UIColor clearColor];
        cardView.layer.borderWidth = 1.0;
        cardView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [self.stationScrollView addSubview:cardView];


    }
    Train *train = [self.locationManager trainWithUCode:self.trainInfoManager.userTrainInfo.trainCode];
    train.railDirection =@"odpt.RailDirection:TokyoMetro.Shinkiba";
    self.railwayLabel.text = [NSString stringWithFormat:@"%@線",railway.title];
    self.directionLabel.text = [NSString stringWithFormat:@"%@方面",ConvertToJapaneseFromDirectionCode(train.railDirection)];
    

    [self.trainInfoManager startConnectionWtihTimeInterval:10];
    
    // 次に到着する駅の情報を初期で表示
    
//    Train *train = [self.locationManager trainWithUCode:self.trainInfoManager.userTrainInfo.trainCode];
    Station *station = railway.stationDict[train.fromStationTrimed];
//    Station *station = railway.stationDict[@"Edogawabashi"];
    self.index = station.order-1;
    
    self.stationScrollView.contentOffset = CGPointMake(self.index * 320, 0);
    self.carSegement.selectedSegmentIndex = self.trainInfoManager.userTrainInfo.carNumber;
    [self updatePositionView];
    
}
- (IBAction)changeCarNumber:(id)sender {
    [self updatePositionView];
}

- (void)updatePositionView {
//#warning this is test
//    Railway *railway = self.railwayManager.allRailway[6];
//    Station *station = railway.stationArray[self.index];
// main
    Station *station = self.railwayManager.userRailway.stationArray[self.index];

    NSDictionary *carNumDict = self.trainInfoManager.trainInfoForView[station.stationName];

    // reset Colorof background
    for (UIButton *btn in self.positionBtns) {
        btn.backgroundColor = RGBA(194, 194, 194 , 61 );
    }
    
    // open position which will be free
    for (NSArray *positions in carNumDict[stringFromNSInteger(self.carSegement.selectedSegmentIndex)]) {
        for (NSString *position in positions) {
            UIButton *positionBtn = self.positionBtns[position.intValue];
            positionBtn.backgroundColor = RGBA(200, 40, 40 , 60);
        }
    }
    
    // message update

    self.carLabel.text = [NSString stringWithFormat:@"%ld 両目は", self.carSegement.selectedSegmentIndex + 1];
    self.dropNumLabel.text = stringFromNSInteger(carNumDict.count);
    self.openSeatNumLabel.text = stringFromNSInteger(carNumDict.count);
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // update view with train info
    self.index = scrollView.contentOffset.x / 320;
    [self updatePositionView];

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

}

- (void)test {
    NSDictionary *dict = @{@"train_code": @"XXXXXX"};
    TrainInfo *testCase = [[TrainInfo alloc]initWithDict:dict];
    self.trainInfoManager.userTrainInfo = testCase;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.trainInfoManager stopConnection];
}

#pragma mark - Train Info Manager Delegate Methods

- (void)trainInfoManager:(TrainInfoManager *)manager didRecievedTrainInfos:(NSArray *)trainInfos {
    for (TrainInfo *trainInfo in trainInfos) {
        LOG(@"%@",trainInfo.trainCode);
    }
    [self updatePositionView];
}


@end
