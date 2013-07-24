//
//  DailyForecast.m
//  WeatherXML
//
//  Created by George Uno on 3/8/12.
//  Copyright (c) 2012 Kuawa Road Productions. All rights reserved.
//

#import "DailyForecast.h"

@implementation DailyForecast {
    
}

@synthesize period = _period;
@synthesize day = _day;
@synthesize month = _month;
@synthesize weekday = _weekday;
@synthesize weekdayShort = _weekdayShort;
@synthesize conditions = _conditions;
@synthesize icon = _icon;
// INTS
@synthesize precipPercent = _precipPercent;
@synthesize highF = _highF;
@synthesize highC = _highC;
@synthesize lowF = _lowF;
@synthesize lowC = _lowC;
@synthesize sunriseHour = _sunriseHour;
@synthesize sunsetHour = _sunsetHour;

-(NSString *)description {
    NSString *descriptionString = [NSString stringWithFormat:@"#%@ %@ %@/%@ %@ %i/%i (%i/%i)",self.period,self.weekdayShort,self.self.month,self.day,self.conditions,self.highF,self.lowF,self.highC,self.lowC];
    
    return descriptionString;
}

-(void)dealloc
{
    self.period = nil;
    self.day = nil;
    self.month = nil;
    self.weekday = nil;
    self.weekdayShort = nil;
    self.conditions = nil;
    self.icon = nil;
    [super dealloc];
}

@end
