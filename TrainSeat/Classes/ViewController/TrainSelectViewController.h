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

@property (nonatomic , weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic , weak) IBOutlet UIScrollView *lineScrollView;

@property (nonatomic , weak) IBOutlet UISegmentedControl *directionSegment;

- (IBAction)didChangeDirection:(id)sender;

@end
