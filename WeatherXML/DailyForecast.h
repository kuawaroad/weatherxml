//
//  DailyForecast.h
//  WeatherXML
//
//  Created by George Uno on 3/8/12.
//  Copyright (c) 2012 Kuawa Road Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyForecast : NSObject {
    NSString *_period;
    NSString *_day;
    NSString *_month;
    NSString *_weekday;
    NSString *_weekdayShort;
    NSString *_conditions;
    NSString *_icon;
    int _precipPercent;
    int _highF;
    int _highC;
    int _lowF;
    int _lowC;
    int _sunriseHour;
    int _sunsetHour;
}

@property (nonatomic,strong) NSString *period;
@property (nonatomic,strong) NSString *day;
@property (nonatomic,strong) NSString *month;
@property (nonatomic,strong) NSString *weekday;
@property (nonatomic,strong) NSString *weekdayShort;
@property (nonatomic,strong) NSString *conditions;
@property (nonatomic,strong) NSString *icon;

@property (nonatomic,assign) int precipPercent;
@property (nonatomic,assign) int highF;
@property (nonatomic,assign) int highC;
@property (nonatomic,assign) int lowF;
@property (nonatomic,assign) int lowC;
@property (nonatomic,assign) int sunriseHour;
@property (nonatomic,assign) int sunsetHour;

@end
