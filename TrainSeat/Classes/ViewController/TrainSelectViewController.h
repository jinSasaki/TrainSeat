//
//  TrainSelectViewController.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/06.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainMapView.h"
#import "RailwayMapView.h"
#import "RailwayManager.h"
#import "LineButton.h"
#import "LocationManager.h"

@interface TrainSelectViewController : UIViewController
<UIScrollViewDelegate ,LocationManagerDelegate>

@property (nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) IBOutlet UIScrollView *lineScrollView;

@property (nonatomic) IBOutlet UISegmentedControl *directionSegment;

- (IBAction)didChangeDirection:(id)sender;

@end
