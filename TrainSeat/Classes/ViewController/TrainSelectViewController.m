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
    LocationManager *locationManager;
    NSArray *directionArray;
}
@end

@implementation TrainSelectViewController
double nonSelectedAlpha = 0.3;
double selectedAlpha = 1.0;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RailwayManager *manager = [RailwayManager defaultManager];
    locationManager = [LocationManager defaultManager];
    locationManager.delegate = self;

    //--------------------------------------------------------------------------------
    // 路線アイコン
    //-------------------------------------------------------------------------------
    
    double height = self.lineScrollView.frame.size.height;
    double heightLabel = height / 5;
    for (int i=0; i<manager.allRailway.count; i++) {
        Railway *railway = manager.allRailway[i];
        LineButton *button = [[LineButton alloc]initWithFrame:CGRectMake(height*i, 5, height - heightLabel, height  -heightLabel) railwayTitle:railway.title];
        button.railwayName = railway.railwayName;
        button.alpha = nonSelectedAlpha;
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
    // 路線図
    //--------------------------------------------------------------------------------
    
    trainmap = [[TrainMapView alloc]initWithFrame:CGRectMake(0,0, self.scrollView.frame.size.width * 6 ,self.scrollView.frame.size.height* 2) ];
    self.scrollView.contentSize = trainmap.bounds.size;

    // TODO: Fix Hard Cording
    self.scrollView.contentOffset = CGPointMake(500,180);
    self.scrollView.minimumZoomScale = 0.4f;
    self.scrollView.maximumZoomScale = 2.0f;
    self.scrollView.delegate = self;
    [self.scrollView addSubview:trainmap];
    
    
    
    //--------------------------------------------------------------------------------
    // 路線マップ
    //--------------------------------------------------------------------------------



}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [[self.scrollView subviews] objectAtIndex:0];
}

- (void)lineDidPush:(id)sender {
    
    // 一度すべての路線を非選択状態に
    for (RailwayMapView *railwaymap in trainmap.subviews) {
        if ([railwaymap isKindOfClass:[RailwayMapView class]]) {
            railwaymap.alpha = nonSelectedAlpha;
        }
    }
    // 一度すべてのアイコンを非選択状態に
    for (LineButton *lineButton in self.lineScrollView.subviews) {
        if (![lineButton isKindOfClass:[LineButton class]]) continue;
        lineButton.alpha = nonSelectedAlpha;
    }
    
    //
    if (sender) {
        LineButton *pushedButton = sender;
        pushedButton.alpha = selectedAlpha;

        // 路線を表示
        RailwayMapView *railwayMap = [trainmap railwaymapWithRailwayName:pushedButton.railwayName];

        // TODO:  選択された路線を最前面にもってきたいけどなぜか落ちるので後回し
//        [trainmap bringSubviewToFront:railwayMap];
        railwayMap.alpha = selectedAlpha;
        
        [locationManager startConnectionWithRailway:railwayMap.railway];
        
        directionArray = RailDirectionsFromRailway(locationManager.currentRailway.railwayName);

        for (int i=0; i<directionArray.count ; i++ ) {
            
            [self.directionSegment setTitle:[stationTitleWithStationName(directionArray[i]) stringByAppendingString:@"方面"] forSegmentAtIndex:i];
        }
        [self.directionSegment reloadInputViews];

    }
    [trainmap.pinView removeFromSuperview];
    trainmap.pinView = nil;
    [trainmap.flagView removeFromSuperview];
    trainmap.flagView = nil;;
    
    
}

- (IBAction)didChangeDirection:(id)sender {

    [trainmap.pinView removeFromSuperview];
    trainmap.pinView = nil;

    // update train map view
    [trainmap updateTrainMapViewWithRailDirection:directionArray[self.directionSegment.selectedSegmentIndex]];
}



#pragma mark - Location Manager Delegate Methods
- (void)didRecieve {

    LOG(@"didReceived");
    
    // update train map view
    [trainmap updateTrainMapViewWithRailDirection:directionArray[self.directionSegment.selectedSegmentIndex]];
    
}
- (IBAction)didPushNext:(id)sender {
    
    if (!trainmap.pinView) {
        LOG(@"input pin");
        return;
    }
    if (!trainmap.flagView) {
        LOG(@"input flag");
        return;
    }
    
    TrainInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TrainInfo"];
    vc.trainInfo.ridingTrain = [[LocationManager defaultManager]trainWithUCode:trainmap.selectedTrainUCode];
    vc.trainInfo.dstStation = trainmap.selectedStationButton.station;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didStartUpdateing {
    
}
@end
