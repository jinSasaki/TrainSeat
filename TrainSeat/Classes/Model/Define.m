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
