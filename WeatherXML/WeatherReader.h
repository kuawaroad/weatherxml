//
//  WeatherReader.h
//  WeatherXML
//
//  Created by George Uno on 3/8/12.
//  Copyright (c) 2012 Kuawa Road Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ForecastDataModel;

@interface WeatherReader : NSObject {
    
}

+(ForecastDataModel *)loadForecastData;

+(void)saveWeatherDataToDisk:(NSMutableData *)weatherData;

@end
