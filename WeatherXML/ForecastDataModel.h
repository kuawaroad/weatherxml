//
//  ForecastDataModel.h
//  WeatherXML
//
//  Created by George Uno on 3/8/12.
//  Copyright (c) 2012 Kuawa Road Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForecastDataModel : NSObject {
    // iVars
    NSString *_locationCity;
    NSString *_locationState;
    NSString *_locationZip;
    NSString *_locationFull;
    NSString *_weather;
    NSString *_iconName;
    int _currentTempFahrenheit;
    int _currentTempCelsius;
    int _localEpochTime; // use [NSDate date] instead?
    int _localTimezoneOffset;
    NSMutableDictionary *_detailDictionary; // dictionary of condition & value
    /* Dictionary Keys
     precipPercent,precip24Hours,precip1Hour,humidity,windDirection,windGust,windChill,visibility,pressure,dewPoint,UV,sunrise,sunset,moonphase (calculate with ageOfMoon & percentIlluminated.
    */
    NSMutableArray *_tenDayArray; // array of dictionaries for each DAY
    /* Dictionary Keys
     day, month, weekday, highF, highC, lowF, lowC, conditions, icon, precipPercent
    */
}

@property (nonatomic,assign) int localEpochTime;
@property (nonatomic,assign) int localTimezoneOffset;
@property (nonatomic,retain) NSString *locationCity;
@property (nonatomic,retain) NSString *locationState;
@property (nonatomic,retain) NSString *locationZip;
@property (nonatomic,retain) NSString *locationFull;
@property (nonatomic,retain) NSString *weather;
@property (nonatomic,retain) NSString *iconName;
@property (nonatomic,assign) int currentTempFahrenheit;
@property (nonatomic,assign) int currentTempCelsius;
@property (nonatomic,retain) NSMutableDictionary *detailDictionary;
@property (nonatomic,retain) NSMutableArray *tenDayArray;

@end
