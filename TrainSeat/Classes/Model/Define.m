//
//  Define.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

NSString *StringWithOdptType(OdptType input) {
    NSArray *types = @[@"odpt:Train",
                       @"odpt:TrainInformation",
                       @"odpt:StationTimetable",
                       @"odpt:StationFacilety",
                       @"odpt:PassengerSurvey",
                       @"odpt:RailwayFare",
                       @"odpt:Station",
                       @"odpt:Railway"
                       ];
    return (NSString *)[types objectAtIndex:input];
}

NSString *StringWithParameter(Parameter input) {
    NSArray *types = @[@"rdf:type",
                       @"acl:consumerKey",
                       @"@id",
                       @"owl:sameAs",
                       @"odpt:station",
                       @"odpt:railway",
                       @"odpt:operator",
                       @"odpt:railDirection"
                       ];
    return (NSString *)[types objectAtIndex:input];
}

NSArray *RailDirectionsFromRailway(NSString *railwayName){
    
    NSDictionary *dict = @{
                           @"Ginza":@[@"Shibuya",
                                      @"Asakusa"],
                           @"Marunouchi":@[@"Ogikubo",
                                           @"Ikebukuro"],
                           @"MarunouchiBranch":@[@"Honancho",
                                                 @"NakanoSakaue"],
                           @"Hibiya":@[@"NakaMeguro",
                                       @"KitaSenju"],
                           @"Tozai":@[@"Nakano",
                                      @"NishiFunabashi"],
                           @"Chiyoda":@[@"YoyogiUehara",
                                        @"Ayase"],
                           @"Chiyoda2?":@[@"KitaAyase",
                                          @"Ayase"],
                           @"Yurakucho":@[@"Wakoshi",
                                          @"ShinKiba"],
                           @"Hanzomon":@[@"Shibuya",
                                         @"Oshiage"],
                           @"Namboku":@[@"Meguro",
                                        @"AkabaneIwabuchi"],
                           @"Fukutoshin":@[@"Wakoshi",
                                           @"Shibuya"]
                           };
    return dict[railwayName];
    
}

NSString *ConvertToJapaneseFromDirectionCode(NSString *code) {
    NSDictionary *direcitonStations =
    @{
      @"odpt.RailDirection:TokyoMetro.Shibuya":@"渋谷",
      @"odpt.RailDirection:TokyoMetro.Ikebukuro":@"池袋",
      @"odpt.RailDirection:TokyoMetro.Ogikubo":@"荻窪",
      @"odpt.RailDirection:TokyoMetro.NakanoSakaue":@"中野坂上",
      @"odpt.RailDirection:TokyoMetro.Honancho":@"方南町",
      @"odpt.RailDirection:TokyoMetro.Kitasenju":@"北千住",
      @"odpt.RailDirection:TokyoMetro.Nakameguro":@"中目黒",
      @"odpt.RailDirection:TokyoMetro.Nakano":@"中野",
      @"odpt.RailDirection:TokyoMetro.NishiFunabashi":@"西船橋",
      @"odpt.RailDirection:TokyoMetro.Ayase":@"綾瀬",
      @"odpt.RailDirection:TokyoMetro.YoyogiUehara":@"代々木上原",
      @"odpt.RailDirection:TokyoMetro.KitaAyase":@"北綾瀬",
      @"odpt.RailDirection:TokyoMetro.Wakoshi":@"和光市",
      @"odpt.RailDirection:TokyoMetro.Shinkiba":@"新木場",
      @"odpt.RailDirection:TokyoMetro.Oshiage":@"押上",
      @"odpt.RailDirection:TokyoMetro.Meguro":@"目黒",
      @"odpt.RailDirection:TokyoMetro.AkabaneIwabuchi":@"赤羽岩淵",
      };
    return direcitonStations[code];
}
NSString *ConvertToDirectionCodeFromJapanese(NSString *japanese) {
    
    NSDictionary *direcitonStations =
    @{
      @"浅草":@"odpt.RailDirection:TokyoMetro.Asakusa",
      @"渋谷":@"odpt.RailDirection:TokyoMetro.Shibuya",
      @"池袋":@"odpt.RailDirection:TokyoMetro.Ikebukuro",
      @"荻窪":@"odpt.RailDirection:TokyoMetro.Ogikubo",
      @"中野坂上":@"odpt.RailDirection:TokyoMetro.NakanoSakaue",
      @"方南町":@"odpt.RailDirection:TokyoMetro.Honancho",
      @"北千住":@"odpt.RailDirection:TokyoMetro.Kitasenju",
      @"中目黒":@"odpt.RailDirection:TokyoMetro.Nakameguro",
      @"中野":@"odpt.RailDirection:TokyoMetro.Nakano",
      @"西船橋":@"odpt.RailDirection:TokyoMetro.NishiFunabashi",
      @"綾瀬":@"odpt.RailDirection:TokyoMetro.Ayase",
      @"代々木上原":@"odpt.RailDirection:TokyoMetro.YoyogiUehara",
      @"北綾瀬":@"odpt.RailDirection:TokyoMetro.KitaAyase",
      @"和光市":@"odpt.RailDirection:TokyoMetro.Wakoshi",
      @"新木場":@"odpt.RailDirection:TokyoMetro.Shinkiba",
      @"押上":@"odpt.RailDirection:TokyoMetro.Oshiage",
      @"目黒":@"odpt.RailDirection:TokyoMetro.Meguro",
      @"赤羽岩淵":@"odpt.RailDirection:TokyoMetro.AkabaneIwabuchi",
      };
    
    return direcitonStations[japanese];
    
}

NSString *stationTitleWithStationName(NSString *stationName) {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *stationDict = [ud dictionaryForKey:@"stationName"];
    return stationDict[stationName];
}
