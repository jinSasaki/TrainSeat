//
//  Define.h
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/28.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ACCESS_TOKEN @"3b81939a6c9d1b5ba703e05e0855e670053ecd49172013ed7ecb61e3dea28a71"

#define ORIGIN @"https://api.tokyometroapp.jp/api/v2/"
#define ORIGIN_DATA @"https://api.tokyometroapp.jp/api/v2/datapoints"
#define ORIGIN_PLACE @"https://api.tokyometroapp.jp/api/v2/places"

//--------------------------------------------------------------------------------

typedef NS_ENUM(NSInteger, OdptType) {
    OdptTrain = 0,
    OdptTrainInformation,
    OdptStationTimeTable,
    OdptStationFacility,
    OdptPassengerSurvey,
    OdptRailwayFare,
    OdptStation,
    OdptRailway
};

NSString *StringWithOdptType(OdptType input);

//--------------------------------------------------------------------------------

typedef NS_ENUM(NSInteger, Parameter) {
    ParameterRdfType = 0,
    ParameterAccessToken,
    ParameterUcode,
    ParameterSameAs,
    ParameterStation,
    ParameterRailway,
    ParameterOperator,
    ParameterRailDirection
};

NSString *StringWithParameter(Parameter input);

//--------------------------------------------------------------------------------

typedef NS_ENUM(NSUInteger, UserDirection) {
    UserDirectionLeft = 0,
    UserDirectionRight
};

typedef NS_ENUM(NSUInteger,RidingStatus) {
    RidingStatusStanding = 0,
    RidingStatusSittng
};


//--------------------------------------------------------------------------------

NSString *ConvertToJapaneseFromDirectionCode(NSString *code);
NSString *ConvertToDirectionCodeFromJapanese(NSString *japanese);
NSArray *RailDirectionsFromRailway(NSString *railwayName);

NSString *stationTitleWithStationName(NSString *stationName);