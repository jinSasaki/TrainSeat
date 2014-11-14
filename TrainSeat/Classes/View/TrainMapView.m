//
//  TrainMapView.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "TrainMapView.h"

@implementation TrainMapView

const double dLng   = 140;
const double dLat   = -70;
double scale;
const double view_width    = 280;
const double view_height   = 160;

static NSMutableDictionary *_matchList;
static NSMutableDictionary *__groupStations;
static NSMutableDictionary *__stationDict;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    
    scale = frame.size.width / view_width;
    
    self.railwayMap = [[UIView alloc]initWithFrame:frame];
    self.staionsMap = [[UIView alloc]initWithFrame:frame];
    //    self.trainMap = [[UIView alloc]initWithFrame:frame];
    _matchList = [NSMutableDictionary dictionary];
    __stationDict = [NSMutableDictionary dictionary];
    
    NSArray *locationArray = [self parseJSONFromString:locationJSON];
    for (NSDictionary *dict in locationArray) {
        StationButton *addButton = [self createStationButtonFromInfo:dict];
        addButton.tag = count;
        [_matchList setObject:@(count) forKey:[self removeDashFromString:[dict objectForKey:@"station"]]];
        [self.staionsMap addSubview:addButton];
        count++;
    }
    
    self.stationDict = __stationDict;
    
    [self addSubview:self.railwayMap];
    //    [self addSubview:self.trainMap];
    [self addSubview:self.staionsMap];
    
    return self;
}
- (NSDictionary *)matchList {
    return _matchList;
}


- (NSArray *)parseJSONFromString:(NSString *)jsonString {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUnicodeStringEncoding];
    
    // JSON を NSArray に変換する
    NSError *error;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:NSJSONReadingAllowFragments
                                                       error:&error];
    return array;
}

- (NSString *)removeDashFromString:(NSString *)string {
    NSRange searchResult = [string rangeOfString:@"-"];
    if(searchResult.location == NSNotFound){
        return [string capitalizedString];
    }
    
    NSArray *strs = [string componentsSeparatedByString:@"-"];
    NSString *result = @"";
    for (int i=0 ; i<strs.count ; i++) {
        result = [result stringByAppendingString:[strs[i] capitalizedString]];
    }
    return result;
    
    
}

- (void)updateTrainMapView {
    
    for (id view in self.staionsMap.subviews) {
        if ([view isKindOfClass:[TrainView class]]) {
            [view removeFromSuperview];
        }
    }
    
    LocationManager *locationManager = [LocationManager defaultManager];
    for (Train *train in locationManager.trainArray) {
        TrainView *trainView = [[TrainView alloc]initWithFrame:CGRectMake(0, 0, 40, 20) train:train railway:self.currentRailway trainDidSelectSelector:@selector(trainIconDidPush:)];
        trainView.center = train.center;
        [self.staionsMap addSubview:trainView];
    }
    
}
- (void)updateTrainMapViewWithRailDirection:(NSString *)direction {
    
    [self updateTrainMapView];
    self.currentDirection = direction;
    for (id view in self.staionsMap.subviews) {
        if (![view isKindOfClass:[TrainView class]]) {
            continue;
        }
        TrainView *trainView = view;
        if ([trainView.train.railDirection compare:direction] == NSOrderedSame) {
            trainView.hidden = NO;
        }else {
            trainView.hidden = YES;
        }        
        if ([trainView.train.ucode compare:self.selectedTrainUCode] == NSOrderedSame) {
            trainView.isSelected = YES;
            self.pinView.center = trainView.center;
        }
    }
}


- (StationButton *)createStationButtonFromInfo:(NSDictionary *)stationInfo{
    
    double lng1 = [[stationInfo objectForKey:@"lng1"] doubleValue];
    double lng2 = [[stationInfo objectForKey:@"lng2"] doubleValue];
    double lat1 = [[stationInfo objectForKey:@"lat1"] doubleValue];
    double lat2 = [[stationInfo objectForKey:@"lat2"] doubleValue];
    
    double x1 = lng1 + dLng;
    double x2 = lng2 + dLng;
    double y1 = -1 * (lat1 + dLat);
    double y2 = -1 * (lat2 + dLat);
    
    x1 *= scale;
    x2 *= scale;
    y1 *= scale;
    y2 *= scale;
    
    NSString *name = [self removeDashFromString:[[stationInfo objectForKey:@"station"] capitalizedString]];
    
    double width =  abs(x1 - x2) * 0.8;
    double height = abs(y2 - y1) * 0.8;
    
    RailwayManager *manager = [RailwayManager defaultManager];
    Station *station = manager.allStationDict[name];
    StationButton *button = [StationButton buttonWithType:UIButtonTypeSystem frame:CGRectMake(x1, y1, width, height) station:station];
    [button setTitle:[manager stationTitleWithStationName:name] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(stationBtnDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [__stationDict setObject:button forKey:station.stationName];
    
    return button;
}


- (RailwayMapView *)railwaymapWithRailwayName:(NSString *)railwayName {
    for (RailwayMapView *railwayMap in self.railwayMap.subviews) {
        if ([railwayMap.railwayName compare:railwayName] == NSOrderedSame) {
            return railwayMap;
        }
    }
    LOG(@"%@ return nil",railwayName);
    return nil;
}

- (RailwayMapView *)railwaymapWithTitle:(NSString *)title {
    for (RailwayMapView *railwayMap in self.railwayMap.subviews) {
        if ([railwayMap.railwayName compare:title] == NSOrderedSame) {
            return railwayMap;
        }
    }
    return nil;
    
}

- (void)groupStationsOnRailways:(NSArray *)railways {
    
    __groupStations = [NSMutableDictionary dictionary];
    
    NSArray *stations = self.staionsMap.subviews;
    for (Railway *railway in railways) {
        NSArray *array = [self createArrayGroupStationsOnRailway:stations railway:railway];
        [__groupStations setObject:array forKey:railway.railwayName];
    }
    self.groupStations = __groupStations;
}

- (NSArray *)createArrayGroupStationsOnRailway:(NSArray *)stations railway:(Railway *)railway {
    NSMutableArray *array = [NSMutableArray array];
    for (StationButton *stationBtn in stations) {
        for (NSString *stationName in railway.order) {
            if ([stationBtn.staion.stationName compare:stationName] == NSOrderedSame) {
                [array addObject:stationBtn];
                continue;
            }
        }
    }
    return array;
    
}
- (void)nonSelectedStatusAllStations:(double)alpha {
    for (StationButton *stationBtn in self.staionsMap.subviews) {
        stationBtn.alpha = alpha;
    }
}
- (void)selectedStaionOnRailway:(Railway *)railway alpha:(double)alpha {
    self.currentRailway = railway;
    
    for (StationButton *stationBtn in self.groupStations[railway.railwayName]) {
        stationBtn.alpha = alpha;
    }
}

- (void)stationBtnDidPush:(id)sender
{
    LOG_METHOD;
    StationButton *button = sender;
    if (!self.flagView) {
        self.flagView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 40)];
        self.flagView.image = [UIImage imageNamed:@"flag.png"];
        self.flagView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.flagView];
    }
    if ([button.staion.railwayCode compare:self.currentRailway.code] == NSOrderedSame) {
        self.flagView.center = CGPointMake(button.center.x, button.center.y - 10);
    }
}

- (void)trainIconDidPush:(id)sender
{
    LOG_METHOD;
    UIButton *trainIcon = sender;
    TrainView *superView = (TrainView *)trainIcon.superview;
    self.selectedTrainUCode = superView.train.ucode;

    if (!self.pinView) {
        self.pinView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 40)];
        self.pinView.image = [UIImage imageNamed:@"pin.png"];
        self.pinView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.pinView];
    }
    self.pinView.center = CGPointMake(superView.center.x, superView.center.y - 10);
}

//--------------------------------------------------------------------------------
// 駅の座標データ
//--------------------------------------------------------------------------------

// lat += 60
// lng += 140
// (5,7) - (128,268)
// 倍率は x5 が妥当？
// 駅名の頭が小文字になってる ==> capitalizedString

NSString *locationJSON = @"[{ \"station\": \"shibuya\", \"lat1\": \"-33.504\", \"lng1\": \"-86.8359375\", \"lat2\": \"-39.0277188402116\", \"lng2\": \"-75.9375\" }, { \"station\": \"omote-sando\", \"lat1\": \"-21.69826549685252\", \"lng1\": \"-71.89453125\", \"lat2\": \"-30.826780904779774\", \"lng2\": \"-66.62109375\" }, { \"station\": \"gaiemmae\", \"lat1\": \"-19.062117883514652\", \"lng1\": \"-64.51171875\", \"lat2\": \"-21.53484700204879\", \"lng2\": \"-54.4921875\" }, { \"station\": \"aoyama-itchome\", \"lat1\": \"-11.781325296112277\", \"lng1\": \"-65.0390625\", \"lat2\": \"-15.368949896534692\", \"lng2\": \"-55.1953125\" }, { \"station\": \"akasaka-mitsuke\", \"lat1\": \"-9.535748998133615\", \"lng1\": \"-51.6796875\", \"lat2\": \"-19.559790136497398\", \"lng2\": \"-46.40625\" }, { \"station\": \"tameike-sanno\", \"lat1\": \"-22.83694592094384\", \"lng1\": \"-44.296875\", \"lat2\": \"-32.026706293336126\", \"lng2\": \"-38.3203125\" }, { \"station\": \"toranomon\", \"lat1\": \"-26.667095801104804\", \"lng1\": \"-30.76171875\", \"lat2\": \"-34.52466147177172\", \"lng2\": \"-27.94921875\" }, { \"station\": \"shimbashi\", \"lat1\": \"-33.504759069226075\", \"lng1\": \"-11.07421875\", \"lat2\": \"-41.046216814520626\", \"lng2\": \"-7.55859375\" }, { \"station\": \"ginza\", \"lat1\": \"-25.562265014427492\", \"lng1\": \"-0.17578125\", \"lat2\": \"-30.372875188118016\", \"lng2\": \"10.37109375\" }, { \"station\": \"kyobashi\", \"lat1\": \"-12.46876014482322\", \"lng1\": \"18.10546875\", \"lat2\": \"-14.519780046326085\", \"lng2\": \"25.3125\" }, { \"station\": \"nihombashi\", \"lat1\": \"-4.302591077119676\", \"lng1\": \"20.7421875\", \"lat2\": \"-9.709057068618208\", \"lng2\": \"31.640625\" }, { \"station\": \"mitsukoshimae\", \"lat1\": \"5.878332109674327\", \"lng1\": \"24.609375\", \"lat2\": \"2.8991526985043135\", \"lng2\": \"34.62890625\" }, { \"station\": \"kanda\", \"lat1\": \"16.720385051694\", \"lng1\": \"20.7421875\", \"lat2\": \"13.325484885597936\", \"lng2\": \"30.5859375\" }, { \"station\": \"suehirocho\", \"lat1\": \"31.12819929911196\", \"lng1\": \"21.62109375\", \"lat2\": \"27.605670826465445\", \"lng2\": \"29.00390625\" }, { \"station\": \"ueno-hirokoji\", \"lat1\": \"41.44272637767212\", \"lng1\": \"20.7421875\", \"lat2\": \"33.797408767572485\", \"lng2\": \"24.2578125\" }, { \"station\": \"ueno\", \"lat1\": \"50.90303283111257\", \"lng1\": \"31.11328125\", \"lat2\": \"47.2195681123155\", \"lng2\": \"42.36328125\" }, { \"station\": \"inaricho\", \"lat1\": \"48.86471476180277\", \"lng1\": \"46.0546875\", \"lat2\": \"41.44272637767212\", \"lng2\": \"48.515625\" }, { \"station\": \"tawaramachi\", \"lat1\": \"48.86471476180277\", \"lng1\": \"55.37109375\", \"lat2\": \"41.57436130598913\", \"lng2\": \"57.83203125\" }, { \"station\": \"asakusa\", \"lat1\": \"52.429222277955105\", \"lng1\": \"62.578125\", \"lat2\": \"50.12057809796007\", \"lng2\": \"72.7734375\" }, { \"station\": \"ogikubo\", \"lat1\": \"37.64903402157866\", \"lng1\": \"-137.4609375\", \"lat2\": \"31.12819929911196\", \"lng2\": \"-133.9453125\" }, { \"station\": \"minami-asagaya\", \"lat1\": \"34.66935854524545\", \"lng1\": \"-129.1992188\", \"lat2\": \"32.47269502206151\", \"lng2\": \"-113.5546875\" }, { \"station\": \"shin-koenji\", \"lat1\": \"30.3728\", \"lng1\": \"-135.703125\", \"lat2\": \"28.381735043223106\", \"lng2\": \"-123.3984375\" }, { \"station\": \"higashi-koenji\", \"lat1\": \"27.76132987450523\", \"lng1\": \"-131.1328125\", \"lat2\": \"25.878994400196202\", \"lng2\": \"-118.4765625\" }, { \"station\": \"shin-nakano\", \"lat1\": \"25.085598897064777\", \"lng1\": \"-123.75\", \"lat2\": \"23.16056330904831\", \"lng2\": \"-113.203125\" }, { \"station\": \"nakano-sakaue\", \"lat1\": \"24.766784522874453\", \"lng1\": \"-108.984375\", \"lat2\": \"21.04349121680354\", \"lng2\": \"-98.61328125\" }, { \"station\": \"nishi-shinjuku\", \"lat1\": \"19.89072302399691\", \"lng1\": \"-102.3046875\", \"lat2\": \"16.88865978738161\", \"lng2\": \"-92.63671875\" }, { \"station\": \"shinjuku\", \"lat1\": \"17.22475820662464\", \"lng1\": \"-88.9453125\", \"lat2\": \"5.353521355337334\", \"lng2\": \"-82.96875\" }, { \"station\": \"shinjuku-sanchome\", \"lat1\": \"14.519780046326085\", \"lng1\": \"-78.57421875\", \"lat2\": \"10.746969318460001\", \"lng2\": \"-68.37890625\" }, { \"station\": \"shinjuku-gyoemmae\", \"lat1\": \"16.55196172197251\", \"lng1\": \"-63.984375\", \"lat2\": \"12.12526421833159\", \"lng2\": \"-50.80078125\" }, { \"station\": \"yotsuya-sanchome\", \"lat1\": \"9.535748998133615\", \"lng1\": \"-70.13671875\", \"lat2\": \"6.227933930268672\", \"lng2\": \"-56.25\" }, { \"station\": \"yotsuya\", \"lat1\": \"7.100892668623654\", \"lng1\": \"-55.72265625\", \"lat2\": \"0.9667509997666425\", \"lng2\": \"-45\" }, { \"station\": \"kokkai-gijidomae\", \"lat1\": \"-14.859850400601037\", \"lng1\": \"-37.6171875\", \"lat2\": \"-25.085598897064763\", \"lng2\": \"-34.1015625\" }, { \"station\": \"kasumigaseki\", \"lat1\": \"-18.895892559415024\", \"lng1\": \"-27.24609375\", \"lat2\": \"-28.84467368077178\", \"lng2\": \"-21.09375\" }, { \"station\": \"tokyo\", \"lat1\": \"-4.653079918274038\", \"lng1\": \"1.58203125\", \"lat2\": \"-10.055402736564224\", \"lng2\": \"12.12890625\" }, { \"station\": \"otemachi\", \"lat1\": \"9.70905706861822\", \"lng1\": \"0.87890625\", \"lat2\": \"4.302591077119676\", \"lng2\": \"11.953125\" }, { \"station\": \"awajicho\", \"lat1\": \"20.879342971957897\", \"lng1\": \"15.1171875\", \"lat2\": \"12.12526421833159\", \"lng2\": \"18.45703125\" }, { \"station\": \"ochanomizu\", \"lat1\": \"40.91351257612757\", \"lng1\": \"2.4609375\", \"lat2\": \"33.21111647241685\", \"lng2\": \"6.15234375\" }, { \"station\": \"hongo-sanchome\", \"lat1\": \"46.73986059969267\", \"lng1\": \"-5.09765625\", \"lat2\": \"39.30029918615029\", \"lng2\": \"-0.703125\" }, { \"station\": \"korakuen\", \"lat1\": \"44.024421519659334\", \"lng1\": \"-26.89453125\", \"lat2\": \"41.178653972331674\", \"lng2\": \"-17.2265625\" }, { \"station\": \"myogadani\", \"lat1\": \"49.55372551347579\", \"lng1\": \"-34.453125\", \"lat2\": \"47.10004469402519\", \"lng2\": \"-25.6640625\" }, { \"station\": \"shin-otsuka\", \"lat1\": \"53.27835301753182\", \"lng1\": \"-44.296875\", \"lat2\": \"50.792047064406866\", \"lng2\": \"-35.15625\" }, { \"station\": \"ikebukuro\", \"lat1\": \"54.826007999094955\", \"lng1\": \"-64.51171875\", \"lat2\": \"48.16608541901253\", \"lng2\": \"-58.53515625\" }, { \"station\": \"honancho\", \"lat1\": \"13.838079936422474\", \"lng1\": \"-129.7265625\", \"lat2\": \"9.535748998133615\", \"lng2\": \"-121.81640625\" }, { \"station\": \"nakano-fujimicho\", \"lat1\": \"18.22935133838667\", \"lng1\": \"-135\", \"lat2\": \"15.199386048560006\", \"lng2\": \"-115.6640625\" }, { \"station\": \"nakano-shimbashi\", \"lat1\": \"22.024545601240337\", \"lng1\": \"-127.265625\", \"lat2\": \"19.062117883514652\", \"lng2\": \"-113.203125\" }, { \"station\": \"naka-meguro\", \"lat1\": \"-42.87596410238254\", \"lng1\": \"-98.0859375\", \"lat2\": \"-49.667627822621924\", \"lng2\": \"-94.21875\" }, { \"station\": \"ebisu\", \"lat1\": \"-44.77793589631622\", \"lng1\": \"-82.79296875\", \"lat2\": \"-47.69497434186281\", \"lng2\": \"-72.7734375\" }, { \"station\": \"hiro-o\", \"lat1\": \"-42.74701217318065\", \"lng1\": \"-65.91796875\", \"lat2\": \"-45.02695045318544\", \"lng2\": \"-57.65625\" }, { \"station\": \"roppongi\", \"lat1\": \"-38.34165619279593\", \"lng1\": \"-58.7109375\", \"lat2\": \"-41.046216814520626\", \"lng2\": \"-48.69140625\" }, { \"station\": \"kamiyacho\", \"lat1\": \"-33.21111647241684\", \"lng1\": \"-39.19921875\", \"lat2\": \"-39.70718665682654\", \"lng2\": \"-34.453125\" }, { \"station\": \"hibiya\", \"lat1\": \"-12.811801316582605\", \"lng1\": \"-12.65625\", \"lat2\": \"-21.861498734372553\", \"lng2\": \"-8.0859375\" }, { \"station\": \"higashi-ginza\", \"lat1\": \"-27.605670826465445\", \"lng1\": \"12.65625\", \"lat2\": \"-35.675147436084664\", \"lng2\": \"16.171875\" }, { \"station\": \"tsukiji\", \"lat1\": \"-32.026706293336126\", \"lng1\": \"21.97265625\", \"lat2\": \"-35.81781315869662\", \"lng2\": \"28.4765625\" }, { \"station\": \"hatchobori\", \"lat1\": \"-22.024545601240327\", \"lng1\": \"29.70703125\", \"lat2\": \"-25.562265014427492\", \"lng2\": \"39.90234375\" }, { \"station\": \"kayabacho\", \"lat1\": \"-11.264612212504426\", \"lng1\": \"34.8046875\", \"lat2\": \"-16.8886597873816\", \"lng2\": \"45.3515625\" }, { \"station\": \"ningyocho\", \"lat1\": \"7.27529233637217\", \"lng1\": \"41.30859375\", \"lat2\": \"3.601142320158735\", \"lng2\": \"51.50390625\" }, { \"station\": \"kodemmacho\", \"lat1\": \"19.559790136497398\", \"lng1\": \"38.84765625\", \"lat2\": \"14.859850400601049\", \"lng2\": \"49.5703125\" }, { \"station\": \"akihabara\", \"lat1\": \"31.728167146023935\", \"lng1\": \"31.46484375\", \"lat2\": \"28.536274512989912\", \"lng2\": \"41.30859375\" }, { \"station\": \"naka-okachimachi\", \"lat1\": \"41.705728515237524\", \"lng1\": \"38.3203125\", \"lat2\": \"34.52466147177175\", \"lng2\": \"41.66015625\" }, { \"station\": \"iriya\", \"lat1\": \"54.1109429427243\", \"lng1\": \"46.40625\", \"lat2\": \"51.12421275782688\", \"lng2\": \"52.03125\" }, { \"station\": \"minowa\", \"lat1\": \"56.607885465009254\", \"lng1\": \"56.77734375\", \"lat2\": \"53.48804553605622\", \"lng2\": \"65.0390625\" }, { \"station\": \"minami-senju\", \"lat1\": \"59.7563950493563\", \"lng1\": \"62.75390625\", \"lat2\": \"58.03137242177637\", \"lng2\": \"72.7734375\" }, { \"station\": \"kita-senju\", \"lat1\": \"65.62202261510642\", \"lng1\": \"63.80859375\", \"lat2\": \"64.1297836764257\", \"lng2\": \"73.828125\" }, { \"station\": \"nakano\", \"lat1\": \"39.57182223734374\", \"lng1\": \"-110.5664063\", \"lat2\": \"31.877557643340015\", \"lng2\": \"-106.69921875\" }, { \"station\": \"ochiai\", \"lat1\": \"39.436192999314066\", \"lng1\": \"-92.8125\", \"lat2\": \"35.53222622770337\", \"lng2\": \"-87.5390625\" }, { \"station\": \"takadanobaba\", \"lat1\": \"40.64730356252251\", \"lng1\": \"-76.9921875\", \"lat2\": \"37.64903402157866\", \"lng2\": \"-66.97265625\" }, { \"station\": \"waseda\", \"lat1\": \"39.436192999314066\", \"lng1\": \"-55.01953125\", \"lat2\": \"31.42866311735861\", \"lng2\": \"-52.91015625\" }, { \"station\": \"kagurazaka\", \"lat1\": \"45.39844997630408\", \"lng1\": \"-44.47265625\", \"lat2\": \"38.479394673276445\", \"lng2\": \"-41.66015625\" }, { \"station\": \"iidabashi\", \"lat1\": \"39.842286020743394\", \"lng1\": \"-36.2109375\", \"lat2\": \"31.27855085894653\", \"lng2\": \"-30.05859375\" }, { \"station\": \"kudanshita\", \"lat1\": \"25.878994400196202\", \"lng1\": \"-26.015625\", \"lat2\": \"16.04581345375217\", \"lng2\": \"-20.0390625\" }, { \"station\": \"takebashi\", \"lat1\": \"14.00869637063467\", \"lng1\": \"-15.99609375\", \"lat2\": \"9.362352822055605\", \"lng2\": \"-8.7890625\" }, { \"station\": \"monzen-nakacho\", \"lat1\": \"-17.056784609942543\", \"lng1\": \"52.91015625\", \"lat2\": \"-21.043491216803528\", \"lng2\": \"63.10546875\" }, { \"station\": \"kiba\", \"lat1\": \"-18.396230138028812\", \"lng1\": \"68.73046875\", \"lat2\": \"-25.244695951306028\", \"lng2\": \"71.71875\" }, { \"station\": \"toyocho\", \"lat1\": \"-18.396230138028812\", \"lng1\": \"79.1015625\", \"lat2\": \"-27.916766641249062\", \"lng2\": \"82.44140625\" }, { \"station\": \"minami-sunamachi\", \"lat1\": \"-15.876809064146757\", \"lng1\": \"88.76953125\", \"lat2\": \"-20.385825381874263\", \"lng2\": \"98.96484375\" }, { \"station\": \"nishi-kasai\", \"lat1\": \"-10.401377554543538\", \"lng1\": \"92.63671875\", \"lat2\": \"-13.838079936422462\", \"lng2\": \"103.0078125\" }, { \"station\": \"kasai\", \"lat1\": \"-3.7765593098768635\", \"lng1\": \"96.328125\", \"lat2\": \"-7.798078531355303\", \"lng2\": \"103.88671875\" }, { \"station\": \"urayasu\", \"lat1\": \"2.8991526985043135\", \"lng1\": \"100.0195313\", \"lat2\": \"-0.9667509997666298\", \"lng2\": \"107.40234375\" }, { \"station\": \"minami-gyotoku\", \"lat1\": \"8.841651120809145\", \"lng1\": \"103.5351563\", \"lat2\": \"5.178482088522876\", \"lng2\": \"114.08203125\" }, { \"station\": \"gyotoku\", \"lat1\": \"15.368949896534705\", \"lng1\": \"107.2265625\", \"lat2\": \"11.43695521614319\", \"lng2\": \"114.9609375\" }, { \"station\": \"myoden\", \"lat1\": \"21.20745873048264\", \"lng1\": \"111.09375\", \"lat2\": \"17.727758609852284\", \"lng2\": \"118.65234375\" }, { \"station\": \"baraki-nakayama\", \"lat1\": \"30.06909396443887\", \"lng1\": \"105.9960938\", \"lat2\": \"26.03704188651584\", \"lng2\": \"117.24609375\" }, { \"station\": \"nishi-funabashi\", \"lat1\": \"25.878994400196202\", \"lng1\": \"118.3007813\", \"lat2\": \"22.187404991398786\", \"lng2\": \"128.3203125\" }, { \"station\": \"yoyogi-uehara\", \"lat1\": \"-21.861498734372553\", \"lng1\": \"-109.1601563\", \"lat2\": \"-30.977609093348686\", \"lng2\": \"-105.64453125\" }, { \"station\": \"yoyogi-koen\", \"lat1\": \"-12.297068292853803\", \"lng1\": \"-96.15234375\", \"lat2\": \"-25.403584973186703\", \"lng2\": \"-93.69140625\" }, { \"station\": \"meiji-jingumae\", \"lat1\": \"-21.20745873048264\", \"lng1\": \"-81.03515625\", \"lat2\": \"-30.67571540416773\", \"lng2\": \"-77.16796875\" }, { \"station\": \"nogizaka\", \"lat1\": \"-25.244695951306028\", \"lng1\": \"-60.64453125\", \"lat2\": \"-29.91685223307016\", \"lng2\": \"-52.55859375\" }, { \"station\": \"akasaka\", \"lat1\": \"-22.512556954051437\", \"lng1\": \"-51.85546875\", \"lat2\": \"-26.35249785815401\", \"lng2\": \"-45.87890625\" }, { \"station\": \"nijubashimae\", \"lat1\": \"-1.845383988573187\", \"lng1\": \"-13.88671875\", \"lat2\": \"-6.402648405963884\", \"lng2\": \"-0.52734375\" }, { \"station\": \"shin-ochanomizu\", \"lat1\": \"32.32427558887655\", \"lng1\": \"5.80078125\", \"lat2\": \"22.998851594142913\", \"lng2\": \"9.84375\" }, { \"station\": \"yushima\", \"lat1\": \"40.64730356252251\", \"lng1\": \"11.953125\", \"lat2\": \"37.37015718405753\", \"lng2\": \"19.16015625\" }, { \"station\": \"nezu\", \"lat1\": \"50.233151832472245\", \"lng1\": \"6.328125\", \"lat2\": \"48.516604348867475\", \"lng2\": \"14.58984375\" }, { \"station\": \"sendagi\", \"lat1\": \"56.31653672211301\", \"lng1\": \"0.52734375\", \"lat2\": \"54.62297813269033\", \"lng2\": \"11.25\" }, { \"station\": \"nishi-nippori\", \"lat1\": \"61.81466389468391\", \"lng1\": \"4.39453125\", \"lat2\": \"59.7563950493563\", \"lng2\": \"14.58984375\" }, { \"station\": \"machiya\", \"lat1\": \"64.51064316846676\", \"lng1\": \"33.57421875\", \"lat2\": \"59.93300042374631\", \"lng2\": \"37.44140625\" }, { \"station\": \"ayase\", \"lat1\": \"67.7760253890732\", \"lng1\": \"78.22265625\", \"lat2\": \"66.33750501996518\", \"lng2\": \"87.890625\" }, { \"station\": \"kita-ayase\", \"lat1\": \"69.56522590149099\", \"lng1\": \"93.33984375\", \"lat2\": \"68.366801093914\", \"lng2\": \"103.7109375\" }, { \"station\": \"wakoshi\", \"lat1\": \"64.66151739623561\", \"lng1\": \"-128.4960938\", \"lat2\": \"60.02095215374802\", \"lng2\": \"-124.62890625\" }, { \"station\": \"chikatetsu-narimasu\", \"lat1\": \"62.30879369102805\", \"lng1\": \"-119.3554688\", \"lat2\": \"57.468589192089325\", \"lng2\": \"-115.6640625\" }, { \"station\": \"chikatetsu-akatsuka\", \"lat1\": \"60.88770004207789\", \"lng1\": \"-111.796875\", \"lat2\": \"56.022948079627454\", \"lng2\": \"-108.28125\" }, { \"station\": \"heiwadai\", \"lat1\": \"58.859223547066584\", \"lng1\": \"-104.2382813\", \"lat2\": \"53.38332836757153\", \"lng2\": \"-101.07421875\" }, { \"station\": \"hikawadai\", \"lat1\": \"57.938183012205315\", \"lng1\": \"-96.85546875\", \"lat2\": \"52.38332836757153\", \"lng2\": \"-93.33984375\" }, { \"station\": \"kotake-mukaihara\", \"lat1\": \"58.03137242177637\", \"lng1\": \"-86.8359375\", \"lat2\": \"52.53627304145948\", \"lng2\": \"-82.96875\" }, { \"station\": \"senkawa\", \"lat1\": \"57.75107598132104\", \"lng1\": \"-79.1015625\", \"lat2\": \"52.64306343665892\", \"lng2\": \"-75.5859375\" }, { \"station\": \"kanamecho\", \"lat1\": \"56.607885465009254\", \"lng1\": \"-71.71875\", \"lat2\": \"51.01375465718821\", \"lng2\": \"-68.02734375\" }, { \"station\": \"higashi-ikebukuro\", \"lat1\": \"53.48804553605622\", \"lng1\": \"-54.84375\", \"lat2\": \"46.98025235521883\", \"lng2\": \"-52.20703125\" }, { \"station\": \"gokokuji\", \"lat1\": \"50.56928286558243\", \"lng1\": \"-47.98828125\", \"lat2\": \"43.89789239125797\", \"lng2\": \"-45.52734375\" }, { \"station\": \"edogawabashi\", \"lat1\": \"50.00773901463687\", \"lng1\": \"-40.078125\", \"lat2\": \"41.046216814520626\", \"lng2\": \"-37.44140625\" }, { \"station\": \"ichigaya\", \"lat1\": \"23.805449612314625\", \"lng1\": \"-46.23046875\", \"lat2\": \"20.550508894195637\", \"lng2\": \"-36.03515625\" }, { \"station\": \"kojimachi\", \"lat1\": \"10.574222078332806\", \"lng1\": \"-43.41796875\", \"lat2\": \"6.751896464843375\", \"lng2\": \"-35.33203125\" }, { \"station\": \"nagatacho\", \"lat1\": \"-0.615222552406841\", \"lng1\": \"-46.93359375\", \"lat2\": \"-6.402648405963884\", \"lng2\": \"-36.2109375\" }, { \"station\": \"sakuradamon\", \"lat1\": \"-6.577303118123875\", \"lng1\": \"-31.9921875\", \"lat2\": \"-11.781325296112277\", \"lng2\": \"-23.203125\" }, { \"station\": \"yurakucho\", \"lat1\": \"-11.436955216143177\", \"lng1\": \"-2.109375\", \"lat2\": \"-20.879342971957897\", \"lng2\": \"1.58203125\" }, { \"station\": \"ginza-itchome\", \"lat1\": \"-19.559790136497398\", \"lng1\": \"10.72265625\", \"lat2\": \"-22.512556954051437\", \"lng2\": \"26.54296875\" }, { \"station\": \"shintomicho\", \"lat1\": \"-27.137368359795584\", \"lng1\": \"24.609375\", \"lat2\": \"-29.305561325527698\", \"lng2\": \"34.98046875\" }, { \"station\": \"tsukishima\", \"lat1\": \"-32.76880048488168\", \"lng1\": \"32.51953125\", \"lat2\": \"-35.96022296929668\", \"lng2\": \"42.36328125\" }, { \"station\": \"toyosu\", \"lat1\": \"-37.5097258429375\", \"lng1\": \"42.890625\", \"lat2\": \"-40.51379915504413\", \"lng2\": \"52.734375\" }, { \"station\": \"tatsumi\", \"lat1\": \"-38.61687046392973\", \"lng1\": \"56.07421875\", \"lat2\": \"-41.96765920367816\", \"lng2\": \"61.69921875\" }, { \"station\": \"shin-kiba\", \"lat1\": \"-36.80928470205938\", \"lng1\": \"68.203125\", \"lat2\": \"-44.4023918290939\", \"lng2\": \"71.71875\" }, { \"station\": \"hanzomon\", \"lat1\": \"10.574222078332806\", \"lng1\": \"-34.27734375\", \"lat2\": \"7.100892668623654\", \"lng2\": \"-23.90625\" }, { \"station\": \"jimbocho\", \"lat1\": \"25.878994400196202\", \"lng1\": \"-11.6015625\", \"lat2\": \"16.3833911236084\", \"lng2\": \"-7.55859375\" }, { \"station\": \"suitengumae\", \"lat1\": \"1.3182430568620136\", \"lng1\": \"49.74609375\", \"lat2\": \"-3.601142320158722\", \"lng2\": \"60.46875\" }, { \"station\": \"kiyosumi-shirakawa\", \"lat1\": \"-1.1425024037061522\", \"lng1\": \"62.9296875\", \"lat2\": \"-4.653079918274038\", \"lng2\": \"72.7734375\" }, { \"station\": \"sumiyoshi\", \"lat1\": \"17.727758609852284\", \"lng1\": \"79.27734375\", \"lat2\": \"8.841651120809145\", \"lng2\": \"83.84765625\" }, { \"station\": \"kinshicho\", \"lat1\": \"34.23451236236987\", \"lng1\": \"79.62890625\", \"lat2\": \"25.878994400196202\", \"lng2\": \"83.671875\" }, { \"station\": \"oshiage\", \"lat1\": \"50.56928286558243\", \"lng1\": \"79.62890625\", \"lat2\": \"44.276671273775186\", \"lng2\": \"83.84765625\" }, { \"station\": \"meguro\", \"lat1\": \"-53.488045536056205\", \"lng1\": \"-77.6953125\", \"lat2\": \"-55.72711008504597\", \"lng2\": \"-67.8515625\" }, { \"station\": \"shirokanedai\", \"lat1\": \"-48.04870994288686\", \"lng1\": \"-64.86328125\", \"lat2\": \"-54.21386100064492\", \"lng2\": \"-61.171875\" }, { \"station\": \"shirokane-takanawa\", \"lat1\": \"-48.166085419012525\", \"lng1\": \"-50.9765625\", \"lat2\": \"-54.418929968658254\", \"lng2\": \"-47.109375\" }, { \"station\": \"azabu-juban\", \"lat1\": \"-41.70572851523751\", \"lng1\": \"-43.59375\", \"lat2\": \"-48.51660434886747\", \"lng2\": \"-39.90234375\" }, { \"station\": \"roppongi-itchome\", \"lat1\": \"-34.66935854524544\", \"lng1\": \"-59.58984375\", \"lat2\": \"-37.64903402157864\", \"lng2\": \"-40.78125\" }, { \"station\": \"todaimae\", \"lat1\": \"53.067626642387374\", \"lng1\": \"-4.921875\", \"lat2\": \"50.90303283111257\", \"lng2\": \"5.44921875\" }, { \"station\": \"hon-komagome\", \"lat1\": \"58.309488840677645\", \"lng1\": \"-10.72265625\", \"lat2\": \"56.607885465009254\", \"lng2\": \"0.3515625\" }, { \"station\": \"komagome\", \"lat1\": \"61.48075950007598\", \"lng1\": \"-18.6328125\", \"lat2\": \"59.57885104663186\", \"lng2\": \"-8.96484375\" }, { \"station\": \"nishigahara\", \"lat1\": \"64.4348920430406\", \"lng1\": \"-18.45703125\", \"lat2\": \"62.95522304515911\", \"lng2\": \"-7.3828125\" }, { \"station\": \"oji\", \"lat1\": \"67.7760253890732\", \"lng1\": \"-26.015625\", \"lat2\": \"63.66576033778838\", \"lng2\": \"-22.1484375\" }, { \"station\": \"oji-kamiya\", \"lat1\": \"70.75796562654924\", \"lng1\": \"-31.81640625\", \"lat2\": \"65.62202261510642\", \"lng2\": \"-28.65234375\" }, { \"station\": \"shimo\", \"lat1\": \"68.6245436634471\", \"lng1\": \"-37.96875\", \"lat2\": \"65.83877570688918\", \"lng2\": \"-34.98046875\" }, { \"station\": \"akabane-iwabuchi\", \"lat1\": \"66.96447630005638\", \"lng1\": \"-51.6796875\", \"lat2\": \"65.40344478830778\", \"lng2\": \"-41.30859375\" }, { \"station\": \"zoshigaya\", \"lat1\": \"44.15068115978094\", \"lng1\": \"-69.609375\", \"lat2\": \"41.96765920367816\", \"lng2\": \"-56.25\" }, { \"station\": \"nishi-waseda\", \"lat1\": \"36.70365959719453\", \"lng1\": \"-75.41015625\", \"lat2\": \"33.97980872872454\", \"lng2\": \"-62.578125\" }, { \"station\": \"higashi-shinjuku\", \"lat1\": \"27.17646913189887\", \"lng1\": \"-74.8828125\", \"lat2\": \"24.166802085303214\", \"lng2\": \"-64.86328125\" }, { \"station\": \"kita-sando\", \"lat1\": \"-8.102738577783168\", \"lng1\": \"-88.9453125\", \"lat2\": \"-11.049038346537094\", \"lng2\": \"-78.3984375\" }] ";

@end
