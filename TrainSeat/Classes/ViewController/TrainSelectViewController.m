//
//  TrainSelectViewController.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/06.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "TrainSelectViewController.h"

@interface TrainSelectViewController ()
{
    TrainMapView *trainmap;
    NSArray *lineNames;
}
@end

@implementation TrainSelectViewController

const double nonSelected = 0.3;
const double selected = 1.0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RailwayManager *manager = [RailwayManager defaultManager];

    
    //--------------------------------------------------------------------------------
    // 路線アイコン
    //-------------------------------------------------------------------------------
    
    double height = self.lineScrollView.frame.size.height;
    double heightLabel = height / 5;
    for (int i=0; i<manager.allRailway.count; i++) {
        Railway *railway = manager.allRailway[i];
        LineButton *button = [[LineButton alloc]initWithFrame:CGRectMake(height*i, 5, height - heightLabel, height  -heightLabel) railwayTitle:railway.title];
        button.railwayName = railway.railwayName;
        button.alpha = nonSelected;
        [button addTarget:self action:@selector(lineDidPush:) forControlEvents:UIControlEventTouchUpInside];
        [self.lineScrollView addSubview:button];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(height*i, height - heightLabel, height - 10, heightLabel)];
        label.text = railway.title;
        label.font = [UIFont systemFontOfSize:11.0];
        label.textAlignment = UITextAlignmentCenter;
        [self.lineScrollView addSubview:label];
        
    }
    
    self.lineScrollView.contentSize = CGSizeMake(height * manager.allRailway.count, height);

    //--------------------------------------------------------------------------------
    // 駅マップ
    //--------------------------------------------------------------------------------
    
    trainmap = [[TrainMapView alloc]initWithFrame:CGRectMake(0,0, [TrainMapView maxWidth], [TrainMapView maxHeight])];
    self.scrollView.contentSize = trainmap.bounds.size;
    self.scrollView.contentOffset = CGPointMake(1000, 650);
    self.scrollView.minimumZoomScale = 0.4f;
    self.scrollView.maximumZoomScale = 2.0f;
    self.scrollView.delegate = self;
    [self.scrollView addSubview:trainmap];
    
    [trainmap groupStationsOnRailways:manager.allRailway];
    
    
    //--------------------------------------------------------------------------------
    // 路線マップ
    //--------------------------------------------------------------------------------

    int count = 0;
    for (NSString *railwayName in manager.allRailwayDict) {
        Railway *railway = manager.allRailwayDict[railwayName];
        RailwayMapView *railwaymap = [[RailwayMapView alloc]initWithFrame:trainmap.frame stationButtons:trainmap.staionsMap.subviews  stationOrder:railway.order matchList:[trainmap matchList] railwayColor:railway.color];
        [railwaymap setBackgroundColor:[UIColor clearColor]];
        railwaymap.railwayName = railwayName;
        railwaymap.alpha = nonSelected;
        railwaymap.tag = count;
        railwaymap.railway = railway;
        [trainmap.railwayMap addSubview:railwaymap];
        count++;
    }
    [trainmap nonSelectedStatusAllStations:nonSelected];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [[self.scrollView subviews] objectAtIndex:0];
}

- (void)lineDidPush:(id)sender {
    
    for (RailwayMapView *railwaymap in trainmap.railwayMap.subviews) {
        railwaymap.alpha = nonSelected;
    }
    for (LineButton *lineButton in self.lineScrollView.subviews) {
        if (![lineButton isKindOfClass:[LineButton class]]) continue;
        lineButton.alpha = nonSelected;
    }
    [trainmap nonSelectedStatusAllStations:nonSelected];
    if (sender) {
        LineButton *pushedButton = sender;
        pushedButton.alpha = selected;

        // 路線を表示
        RailwayMapView *railwayMap = [trainmap railwaymapWithRailwayName:pushedButton.railwayName];
        railwayMap.alpha = selected;
        [trainmap selectedStaionOnRailway:railwayMap.railway alpha:selected];
        
    }
}


@end
