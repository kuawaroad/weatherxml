//
//  ForecastDataModel.m
//  WeatherXML
//
//  Created by George Uno on 3/8/12.
//  Copyright (c) 2012 Kuawa Road Productions. All rights reserved.
//

#define kDetailDictCapacity 20
#define kTenDayArrayCapacity 10

#import "ForecastDataModel.h"

@implementation ForecastDataModel

@synthesize localEpochTime = _localEpochTime;
@synthesize localTimezoneOffset = _localTimezoneOffset;
@synthesize locationZip = _locationZip;
@synthesize locationCity = _locationCity;
@synthesize locationFull= _locationFull;
@synthesize locationState = _locationState;
@synthesize weather = _weather;
@synthesize iconName = _iconName;
@synthesize currentTempCelsius = _currentTempCelsius;
@synthesize currentTempFahrenheit = _currentTempFahrenheit;
@synthesize detailDictionary = _detailDictionary;
@synthesize tenDayArray = _tenDayArray;

-(id)init {
    if ((self = [super init])) {
        self.detailDictionary = [[[NSMutableDictionary alloc] initWithCapacity:kDetailDictCapacity] autorelease];
        self.tenDayArray = [[[NSMutableArray alloc] initWithCapacity:kTenDayArrayCapacity] autorelease];
    }
    return self;
}
  
-(NSString *)description {
    // MM/DD - Weather - LocationFull - (F/C)
    // Detail Dict...
    // TenDayArray...
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *descriptionString = [NSString stringWithFormat:@"\n%@ - %@ - %@ (%i/%i)\nDETAIL DICT:\n%@\n\nTEN DAY ARRAY\n%@",[dateFormatter stringFromDate:today],self.weather,self.locationFull,self.currentTempFahrenheit,self.currentTempCelsius,self.detailDictionary,self.tenDayArray];
    
    return descriptionString;
}

-(void)dealloc {
    self.locationCity = nil;
    self.locationZip = nil;
    self.locationState = nil;
    self.locationFull = nil;
    self.weather = nil;
    self.iconName = nil;
    self.detailDictionary = nil;
    self.tenDayArray = nil;
    [super dealloc];
}

@end


