//
//  LineTableViewController.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/11/14.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "LineTableViewController.h"

@interface LineTableViewController ()
{
    double nonSelectedAlpha;
    double selectedAlpha;

}
@end

@implementation LineTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    nonSelectedAlpha = 0.3;
    selectedAlpha = 1.0;

    self.locationManager = [LocationManager defaultManager];
    self.railwayManager = [RailwayManager defaultManager];
    
    
    

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *array = self.currentRailway.stationArray;
    return array.count*2-1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LineTableViewCell *cell;

    if (indexPath.row % 2 == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"station" forIndexPath:indexPath];
        Station *station = self.railwayManager.allStations[self.currentRailway.order[indexPath.row/2]];
        cell.stationIcon.image = [UIImage imageNamed:station.stationCode];
        cell.stationTitle.text = station.title;
        
    }else if(indexPath.row % 2 == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"interval" forIndexPath:indexPath];
        cell.line.backgroundColor = self.currentRailway.color;
    }
    
    
    return cell;
}

//カスタマイズするheaderSectionの高さ指定
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

//実際にカスタマイズを行う部分
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!self.lineScrollView) {
        [self initLineScrollView];
    }
    return self.lineScrollView;
}

- (void)initLineScrollView {
    self.lineScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    double height = self.lineScrollView.frame.size.height;
    double heightLabel = height / 5;
    for (int i=0; i<self.railwayManager.allRailway.count; i++) {
        Railway *railway = self.railwayManager.allRailway[i];
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
    self.lineScrollView.backgroundColor = [UIColor whiteColor];
    self.lineScrollView.contentSize = CGSizeMake(height * self.railwayManager.allRailway.count, height);
    self.lineScrollView.bounces = NO;
}

- (void)lineDidPush:(id)sender {
    
    // 一度すべてのアイコンを非選択状態に
    for (LineButton *lineButton in self.lineScrollView.subviews) {
        if (![lineButton isKindOfClass:[LineButton class]]) continue;
        lineButton.alpha = nonSelectedAlpha;
    }
    
    //
    if (sender) {
        LineButton *pushedButton = sender;
        pushedButton.alpha = selectedAlpha;
        Railway *railway = self.railwayManager.allRailwayDict[pushedButton.railwayName];
        self.currentRailway = railway;
        [self.tableView reloadData];

    }
    
}

@end
