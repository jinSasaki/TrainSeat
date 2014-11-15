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
    self.locationManager.delegate = self;
    
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
    NSInteger num = self.currentRailway.stationArray.count * 2 -1;
    if (num < 1) {
        num = 1;
    }
    return num;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LineTableViewCell *cell;
    if (!self.currentRailway) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"init" forIndexPath:indexPath];
        return cell;
    }
    
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
    return 60;
}

//実際にカスタマイズを行う部分
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!self.lineScrollView) {
        [self initLineScrollView];
    }
    return self.lineScrollView;
}

- (void)initLineScrollView {
    self.lineScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    
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
    self.lineScrollView.backgroundColor = RGBA(244, 244, 244, 55);
    self.lineScrollView.contentSize = CGSizeMake(height * self.railwayManager.allRailway.count, height);
    self.lineScrollView.bounces = NO;
}

- (void)lineDidPush:(id)sender {
    
    self.selectedTrainCode = nil;
    self.selectedStation = nil;
    
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
        [self.locationManager startConnectionWithRailway:railway];
        
    }
    
}

#pragma mark - location manager delegate
- (void)didRecieve {
    LOG_METHOD;
    LOG_PRINTF(@"did recieve from location manager");
    
    // 全てのbuttonを一度隠す
    
    for (int i=0; i<[self.tableView numberOfRowsInSection:0]; i++) {
        LineTableViewCell *cell = (LineTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.trainUp.hidden = YES;
        cell.trainDown.hidden = YES;
        cell.train = nil;
        
    }
    
    for (Train *train in self.locationManager.trainArray) {
        
        int predictionNum = 1;
        
        
        NSArray *directions = RailDirectionsFromRailway(self.currentRailway.railwayName);
        Station *fromStation = self.currentRailway.stationDict[train.fromStationTrimed];
        int row = (fromStation.order - 1) * 2;

        Station *directionStation = self.railwayManager.allStations[train.railDirectionOnlyName];
        
        if (directionStation.order < fromStation.order) {
            // 上向きのところのcellを更新
            if (!train.isStop) {
                row --;
            }
            row -= predictionNum;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            LineTableViewCell *cell = (LineTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.trainUp.hidden = NO;
            cell.train = train;
            
        }else if(directionStation.order > fromStation.order) {
            // 下向き
            if (!train.isStop) {
                row ++;
            }
            row += predictionNum;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            LineTableViewCell *cell = (LineTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.trainDown.hidden = NO;
            cell.train = train;
        } else {
            // 規定の行き先じゃないときの計算
            LOG_PRINTF(@"this is other direction");
            
        }
        
    }
    
    [self.tableView reloadData];
    
}


- (void)didStartUpdateing {
    
}

// セルが押された
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 1) {
        return;
    }
    Station *station = self.currentRailway.stationArray[indexPath.row / 2];
    self.selectedStation = station;
    LOG(@"%@",self.selectedStation.title);
    self.navigationItem.title = @"乗車中の電車を選択してください";
    
    [self presentNextViewWithValidation];
}


- (IBAction)trainDidPush:(id)sender {
    
    UIButton *trainBtn = sender;
    LineTableViewCell *cell = (LineTableViewCell *)trainBtn.superview.superview.superview;
    self.selectedTrainCode = cell.train.ucode;
    
    LOG_PRINTF(@"%@ -> %@ direction to %@", cell.train.fromStation, cell.train.toStation , cell.train.railDirection);
    [self presentNextViewWithValidation];
    
    
    
}

- (void)presentNextViewWithValidation {
    if (self.selectedTrainCode && self.selectedStation) {
        UserManager *uManager = [UserManager defaultUserManager];
        TrainInfo *info = uManager.currentTrainInfo;
        info.trainCode = self.selectedTrainCode;
        info.destination = self.selectedStation.stationName;
        LOG(@"save train info");
        
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CarInfo"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end