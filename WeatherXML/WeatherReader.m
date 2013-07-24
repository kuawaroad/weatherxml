//
//  WeatherReader.m
//  WeatherXML
//
//  Created by George Uno on 3/8/12.
//  Copyright (c) 2012 Kuawa Road Productions. All rights reserved.
//

//#define kWeatherURL @"http://api.wunderground.com/api/d7cbe71efe83c149/conditions/astronomy/forecast10day/radar/q/83843.xml"
#define kFileAgeCutoff -28800.0 //the negative age of the file in seconds (21,600 = 6 hours | 28800 = 8hrs)

#import "WeatherReader.h"
#import "ForecastDataModel.h"
#import "GDataXMLNode.h"
#import "DailyForecast.h"

@implementation WeatherReader {
    
}

+(NSString *)pathForDataFile {
    //+(NSString *)pathForDataFile:(NSString *)dataFile forSave:(BOOL)forSave {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *completeFileString = [NSString stringWithFormat:@"%i.xml",[[NSUserDefaults standardUserDefaults] integerForKey:@"UserZipCode"]];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:completeFileString];
    
    return documentsPath;
    /* WAS used... DONT NEED BUNDLED COPY BECAUSE NO WEATHER DATA IS TO BE BUNDLED!
    if (forSave == YES || [[NSFileManager defaultManager] fileExistsAtPath:documentsPath] ) {
        return documentsPath;
    } else {
        return [[NSBundle mainBundle] pathForResource:dataFile ofType:@"xml"];
    }*/
}


+(void)saveWeatherDataToDisk:(NSMutableData *)weatherData {
    NSLog(@"Saving Data :: %@",[self pathForDataFile]);
    NSString *filePath = [self pathForDataFile];
    //[weatherData writeToFile:filePath atomically:YES];
    if (![weatherData writeToFile:filePath atomically:YES]) {
        NSLog(@"File save FAILED! - %@",[self pathForDataFile]);
    } else {
        NSLog(@"File saved successfully! - %@",[self pathForDataFile]);
    }
}

+(ForecastDataModel *)loadForecastData {
    // Get the file's attributes...
    NSError *fileAgeError;
    NSDictionary *attributeDict = [[NSFileManager defaultManager] attributesOfItemAtPath:[self pathForDataFile] error:&fileAgeError];
    //DEBUG NSLog(@"FILE ATTRIBUTES\n%@",attributeDict);
    NSDate *fileModDate = [attributeDict objectForKey:@"NSFileModificationDate"];
    NSLog(@"FILE AGE: %f",[fileModDate timeIntervalSinceNow]);
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self pathForDataFile]];
    
    ForecastDataModel *forecastData = [[[ForecastDataModel alloc] init] autorelease];
    
    // Try to load from local file...
    NSMutableData *xmlData = [[[NSMutableData alloc] initWithContentsOfFile:[self pathForDataFile]] autorelease];
    NSError *fileError;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&fileError] autorelease];
    
    //if (attributeDict == nil || doc != nil) NSLog(@"FILE ATTRIBUTES DON'T EXIST!");
    
    if (doc == nil || fileExists == NO || [fileModDate timeIntervalSinceNow] < kFileAgeCutoff || attributeDict == nil) {
        NSLog(@"DOWNLOADING DATA :: %i",[[NSUserDefaults standardUserDefaults] integerForKey:@"UserZipCode"]);
        // If the document didn't load make an API call
        NSString *weatherURL = [NSString stringWithFormat:@"http://api.wunderground.com/api/d7cbe71efe83c149/conditions/astronomy/forecast10day/radar/q/%i.xml",[[NSUserDefaults standardUserDefaults] integerForKey:@"UserZipCode"]];
        
        NSMutableData *downloadData = [[[NSMutableData alloc] initWithContentsOfURL:[NSURL URLWithString:weatherURL]] autorelease];
        NSError *error;
        GDataXMLDocument *downloadDoc = [[[GDataXMLDocument alloc] initWithData:downloadData options:0 error:&error] autorelease];
        doc = downloadDoc;
        xmlData = downloadData;
        [self saveWeatherDataToDisk:xmlData];
        
    }
    
     
    // get all nodes that fit XPath
    NSArray *locationFullArray = [doc nodesForXPath:@"//response/current_observation/display_location/full" error:nil];
    if (locationFullArray.count > 0) {
        GDataXMLElement *fullLocation = (GDataXMLElement *)[locationFullArray objectAtIndex:0];
        forecastData.locationFull = fullLocation.stringValue;
    }
    
    NSArray *locationCityArray = [doc nodesForXPath:@"//response/current_observation/display_location/city" error:nil];
    if (locationCityArray.count > 0) {
        GDataXMLElement *cityLocation = (GDataXMLElement *)[locationCityArray objectAtIndex:0];
        forecastData.locationCity = cityLocation.stringValue;
    }
    
    NSArray *locationStateArray = [doc nodesForXPath:@"//response/current_observation/display_location/state" error:nil];
    if (locationStateArray.count > 0) {
        GDataXMLElement *stateLocation = (GDataXMLElement *)[locationStateArray objectAtIndex:0];
        forecastData.locationState = stateLocation.stringValue;
    }
    
    NSArray *locationZipArray = [doc nodesForXPath:@"//response/current_observation/display_location/zip" error:nil];
    if (locationZipArray.count > 0) {
        GDataXMLElement *zipLocation = (GDataXMLElement *)[locationZipArray objectAtIndex:0];
        forecastData.locationZip = zipLocation.stringValue;
    }
    
    NSArray *weatherArray = [doc nodesForXPath:@"//response/current_observation/weather" error:nil];
    if (weatherArray.count > 0) {
        GDataXMLElement *weatherString = (GDataXMLElement *)[weatherArray objectAtIndex:0];
        forecastData.weather = weatherString.stringValue;   // add .intValue to retrieve 
    }
    
    NSArray *iconArray = [doc nodesForXPath:@"//response/current_observation/icon" error:nil];
    if (iconArray.count > 0) {
        GDataXMLElement *iconString = (GDataXMLElement *)[iconArray objectAtIndex:0];
        forecastData.iconName = iconString.stringValue;   // add .intValue to retrieve 
    }
    
    NSArray *tempFArray = [doc nodesForXPath:@"//response/current_observation/temp_f" error:nil];
    if (tempFArray.count > 0) {
        GDataXMLElement *tempFString = (GDataXMLElement *)[tempFArray objectAtIndex:0];
        forecastData.currentTempFahrenheit = tempFString.stringValue.intValue;   // add .intValue to retrieve 
    }
    
    NSArray *tempCArray = [doc nodesForXPath:@"//response/current_observation/temp_c" error:nil];
    if (tempCArray.count > 0) {
        GDataXMLElement *tempCString = (GDataXMLElement *)[tempCArray objectAtIndex:0];
        forecastData.currentTempCelsius = tempCString.stringValue.intValue;   // add .intValue to retrieve 
    }
    
    // ADD ITEMS TO DETAIL DICTIONARY (16 Total Keys/Values)
// precip%,precip24h,precip1h,humidity,visibility,pressure,wind(speed,gusts,direction,chill),dewpoint,UV,sunrise,sunset,ageOMoon,%illum
    
    NSArray *popArray = [doc nodesForXPath:@"//response/forecast/simpleforecast/forecastdays/forecastday[period = 1]/pop" error:nil];
    if (popArray.count > 0) {
        GDataXMLElement *dayString = (GDataXMLElement *)[popArray objectAtIndex:0];
        [forecastData.detailDictionary setValue:dayString.stringValue forKey:@"precipPercent"]; 
        //NSLog(@"popArray XPATH Test: %@",[forecastData.detailDictionary objectForKey:@"precipPercent"]);
    }
    
    NSArray *precip24Array = [doc nodesForXPath:@"//response/current_observation/precip_today_string" error:nil];
    if (precip24Array.count > 0) {
        GDataXMLElement *precip24Value = (GDataXMLElement *)[precip24Array objectAtIndex:0];
        [forecastData.detailDictionary setValue:precip24Value.stringValue forKey:@"precip24h"]; 
    }
    
    NSArray *precip1Array = [doc nodesForXPath:@"//response/current_observation/precip_1hr_string" error:nil];
    if (precip1Array.count > 0) {
        GDataXMLElement *precip1Value = (GDataXMLElement *)[precip1Array objectAtIndex:0];
        [forecastData.detailDictionary setValue:precip1Value.stringValue forKey:@"precip1h"]; 
    }
    
    NSArray *humidArray = [doc nodesForXPath:@"//response/current_observation/relative_humidity" error:nil];
    if (humidArray.count > 0) {
        GDataXMLElement *humidityValue = (GDataXMLElement *)[humidArray objectAtIndex:0];
        [forecastData.detailDictionary setValue:humidityValue.stringValue forKey:@"humidity"]; 
    }
    
    NSArray *visibleArray = [doc nodesForXPath:@"//response/current_observation/visibility_mi" error:nil];
    if (visibleArray.count > 0) {
        GDataXMLElement *visibilityValue = (GDataXMLElement *)[visibleArray objectAtIndex:0];
        [forecastData.detailDictionary setValue:visibilityValue.stringValue forKey:@"visibility"]; 
    }
    
    NSArray *pressureArray = [doc nodesForXPath:@"//response/current_observation/pressure_in" error:nil];
    if (pressureArray.count > 0) {
        GDataXMLElement *pressureValue = (GDataXMLElement *)[pressureArray objectAtIndex:0];
        [forecastData.detailDictionary setValue:pressureValue.stringValue forKey:@"pressure"]; 
    }
    
    NSArray *windSpeedArray = [doc nodesForXPath:@"//response/current_observation/wind_mph" error:nil];
    if (windSpeedArray.count > 0) {
        GDataXMLElement *windSpeedValue = (GDataXMLElement *)[windSpeedArray objectAtIndex:0];
        [forecastData.detailDictionary setValue:windSpeedValue.stringValue forKey:@"windspeed"]; 
    }
    
    NSArray *windGustArray = [doc nodesForXPath:@"//response/current_observation/wind_gust_mph" error:nil];
    if (windGustArray.count > 0) {
        GDataXMLElement *windGustValue = (GDataXMLElement *)[windGustArray objectAtIndex:0];
        [forecastData.detailDictionary setValue:windGustValue.stringValue forKey:@"windgust"]; 
    }
    
    NSArray *windDirArray = [doc nodesForXPath:@"//response/current_observation/wind_dir" error:nil];
    if (windDirArray.count > 0) {
        GDataXMLElement *windDirValue = (GDataXMLElement *)[windDirArray objectAtIndex:0];
        [forecastData.detailDictionary setValue:windDirValue.stringValue forKey:@"winddirection"]; 
    }
    
    NSArray *windChillArray = [doc nodesForXPath:@"//response/current_observation/windchill_f" error:nil];
    if (windChillArray.count > 0) {
        GDataXMLElement *windChillValue = (GDataXMLElement *)[windChillArray objectAtIndex:0];
        [forecastData.detailDictionary setValue:windChillValue.stringValue forKey:@"windchill"]; 
    }
    
    NSArray *dewpointArray = [doc nodesForXPath:@"//response/current_observation/dewpoint_f" error:nil];
    if (dewpointArray.count > 0) {
        GDataXMLElement *dewpointValue = (GDataXMLElement *)[dewpointArray objectAtIndex:0];
        [forecastData.detailDictionary setValue:dewpointValue.stringValue forKey:@"dewpoint"]; 
    }
    
    NSArray *UVArray = [doc nodesForXPath:@"//response/current_observation/UV" error:nil];
    if (UVArray.count > 0) {
        GDataXMLElement *UVValue = (GDataXMLElement *)[UVArray objectAtIndex:0];
        [forecastData.detailDictionary setValue:UVValue.stringValue forKey:@"uv"]; 
    }

    NSArray *sunriseHourArray = [doc nodesForXPath:@"//response/moon_phase/sunrise/hour" error:nil];
    NSArray *sunriseMinArray = [doc nodesForXPath:@"//response/moon_phase/sunrise/minute" error:nil];
    if (sunriseHourArray.count > 0 && sunriseMinArray.count > 0) {
        GDataXMLElement *sunriseHourValue = (GDataXMLElement *)[sunriseHourArray objectAtIndex:0];
        GDataXMLElement *sunriseMinuteValue = (GDataXMLElement *)[sunriseMinArray objectAtIndex:0];
        //NSString *sunriseString = [NSString stringWithFormat:@"%@:%@",sunriseHourValue.stringValue,sunriseMinuteValue.stringValue];
        [forecastData.detailDictionary setValue:[NSNumber numberWithInt:sunriseHourValue.stringValue.integerValue] forKey:@"sunriseHour"];
        [forecastData.detailDictionary setValue:[NSNumber numberWithInt:sunriseMinuteValue.stringValue.integerValue] forKey:@"sunriseMinute"];
        
    }

    NSArray *sunsetHourArray = [doc nodesForXPath:@"//response/moon_phase/sunset/hour" error:nil];
    NSArray *sunsetMinArray = [doc nodesForXPath:@"//response/moon_phase/sunset/minute" error:nil];
    if (sunsetHourArray.count > 0 && sunsetMinArray.count > 0) {
        GDataXMLElement *sunsetHourValue = (GDataXMLElement *)[sunsetHourArray objectAtIndex:0];
        GDataXMLElement *sunsetMinuteValue = (GDataXMLElement *)[sunsetMinArray objectAtIndex:0];
        //NSString *sunsetString = [NSString stringWithFormat:@"%@:%@",sunsetHourValue.stringValue,sunsetMinuteValue.stringValue];
        [forecastData.detailDictionary setValue:[NSNumber numberWithInt:sunsetHourValue.stringValue.integerValue] forKey:@"sunsetHour"];
        [forecastData.detailDictionary setValue:[NSNumber numberWithInt:sunsetMinuteValue.stringValue.integerValue] forKey:@"sunsetMinute"];
    }

    NSArray *moonAgeArray = [doc nodesForXPath:@"//response/moon_phase/ageOfMoon" error:nil];
    if (moonAgeArray.count > 0) {
        GDataXMLElement *moonAgeValue = (GDataXMLElement *)[moonAgeArray objectAtIndex:0];
        [forecastData.detailDictionary setValue:moonAgeValue.stringValue forKey:@"ageofmoon"]; 
    }

    NSArray *percentIllArray = [doc nodesForXPath:@"//response/moon_phase/percentIlluminated" error:nil];
    if (percentIllArray.count > 0) {
        GDataXMLElement *percentIllValue = (GDataXMLElement *)[percentIllArray objectAtIndex:0];
        [forecastData.detailDictionary setValue:percentIllValue.stringValue forKey:@"illuminated"]; 
    }
    
    for (int i = 1; i < 11; i++) {
        // gets the XPath to the i# day in the 10 day forecast
        DailyForecast *dailyForecast = [[[DailyForecast alloc] init] autorelease];
        NSString *XPathString = [NSString stringWithFormat:@"//response/forecast/simpleforecast/forecastdays/forecastday[period = %i]",i];
        NSArray *oneDayArray = [doc nodesForXPath:XPathString error:nil];
        GDataXMLElement *oneDayResponse = (GDataXMLElement *)[oneDayArray objectAtIndex:0];
        
        // One day response now holds 1 forecast day, let's store it in a DailyForecast object and add to ForecastDataModels tenDayArray.  The current node is FORECAST DAY as you can see from the XPath above...
        
        NSArray *periodArray = [oneDayResponse nodesForXPath:@"./period" error:nil];
        GDataXMLElement *period = (GDataXMLElement *)[periodArray objectAtIndex:0];
        dailyForecast.period = period.stringValue;
        
        NSArray *dayArray = [oneDayResponse nodesForXPath:@"./date/day" error:nil];
        GDataXMLElement *day = (GDataXMLElement *)[dayArray objectAtIndex:0];
        dailyForecast.day = day.stringValue;
        
        NSArray *monthArray = [oneDayResponse nodesForXPath:@"./date/month" error:nil];
        GDataXMLElement *month = (GDataXMLElement *)[monthArray objectAtIndex:0];
        dailyForecast.month = month.stringValue;
        
        NSArray *weekdayArray = [oneDayResponse nodesForXPath:@"./date/weekday" error:nil];
        GDataXMLElement *weekday = (GDataXMLElement *)[weekdayArray objectAtIndex:0];
        dailyForecast.weekday = weekday.stringValue;
        
        NSArray *weekdayShortArray = [oneDayResponse nodesForXPath:@"./date/weekday_short" error:nil];
        GDataXMLElement *weekdayShort = (GDataXMLElement *)[weekdayShortArray objectAtIndex:0];
        dailyForecast.weekdayShort = weekdayShort.stringValue;
        
        NSArray *conditionsArray = [oneDayResponse nodesForXPath:@"./conditions" error:nil];
        GDataXMLElement *conditions = (GDataXMLElement *)[conditionsArray objectAtIndex:0];
        dailyForecast.conditions = conditions.stringValue;
        
        NSArray *iconArray = [oneDayResponse nodesForXPath:@"./icon" error:nil];
        GDataXMLElement *icon = (GDataXMLElement *)[iconArray objectAtIndex:0];
        dailyForecast.icon = icon.stringValue;
        
        // Integers!
        NSArray *precipPercentArray = [oneDayResponse nodesForXPath:@"./pop" error:nil];
        GDataXMLElement *precipPercent = (GDataXMLElement *)[precipPercentArray objectAtIndex:0];
        dailyForecast.precipPercent = precipPercent.stringValue.intValue;
        
        NSArray *highFArray = [oneDayResponse nodesForXPath:@"./high/fahrenheit" error:nil];
        GDataXMLElement *highF = (GDataXMLElement *)[highFArray objectAtIndex:0];
        dailyForecast.highF = highF.stringValue.intValue;
        
        NSArray *lowFArray = [oneDayResponse nodesForXPath:@"./low/fahrenheit" error:nil];
        GDataXMLElement *lowF = (GDataXMLElement *)[lowFArray objectAtIndex:0];
        dailyForecast.lowF = lowF.stringValue.intValue;
        
        NSArray *highCArray = [oneDayResponse nodesForXPath:@"./high/celsius" error:nil];
        GDataXMLElement *highC = (GDataXMLElement *)[highCArray objectAtIndex:0];
        dailyForecast.highC = highC.stringValue.intValue;
        
        NSArray *lowCArray = [oneDayResponse nodesForXPath:@"./low/celsius" error:nil];
        GDataXMLElement *lowC = (GDataXMLElement *)[lowCArray objectAtIndex:0];
        dailyForecast.lowC = lowC.stringValue.intValue;
        
        NSArray *sunriseArray = [doc nodesForXPath:@"//response/moon_phase/sunrise/hour" error:nil];
        GDataXMLElement *sunrise = (GDataXMLElement *)[sunriseArray objectAtIndex:0];
        dailyForecast.sunriseHour = sunrise.stringValue.intValue;
        
        NSArray *sunsetArray = [doc nodesForXPath:@"//response/moon_phase/sunset/hour" error:nil];
        GDataXMLElement *sunset = (GDataXMLElement *)[sunsetArray objectAtIndex:0];
        dailyForecast.sunsetHour = sunset.stringValue.intValue;
        
        /*
         extract a subnode of Forecast Day!
         NSArray *Array = [oneDayResponse nodesForXPath:@"//forecastday/pop" error:nil];
         GDataXMLElement *temp = (GDataXMLElement *)[Array objectAtIndex:0];
         dailyForecast.@property = temp.stringValue.intValue;
        */
        
        /*// Extract data from Child Node @ XPath
        NSArray *Array = [oneDayValue nodesForXPath:@"" error:nil];
        GDataXMLElement *Value = (GDataXMLElement *)[Array objectAtIndex:0];
        dailyForecast.property = Value.stringValue;
        */
        //NSLog(@"ONE DAY ARRAY #%i\n%@",i,[oneDayArray objectAtIndex:0]);
        //NSLog(@"HIGH F ARRAY :: %i",dailyForecast.highF);
        NSLog(@"DAILY FORECAST ::%@",dailyForecast);
        
        // Add each dailyForecast to the tenDayArray
        [forecastData.tenDayArray addObject:dailyForecast];
    } // end FOR loop
    
    /*
    // FOR loop to iterate through 10 forecast days
    NSArray *forecastDaysArray = [doc nodesForXPath:@"//response/forecast/simpleforecast/forecastdays/WILDCARD*******" error:nil];
    if (forecastDaysArray.count > 0) {
        for (int i = 0; i < forecastDaysArray.count; i++) {
            GDataXMLElement *oneDayValue = (GDataXMLElement *)[forecastDaysArray objectAtIndex:i];
            NSArray *oneDayArray = [oneDayValue nodesForXPath:@"/forecastdays/WILDCARD******" error:nil];
            if (oneDayArray.count > 0) {
                
            }
            NSLog(@"ONEDAYARRAY\n%@",forecastDaysArray); // currently forecastDaysArray holds 10 forecastday objects
        }
    } // end if
    */
    /* Fetch a STRING from an XML Node via XPATH
    NSArray *temp = [doc nodesForXPath:@"//response/current_observation/" error:nil];
    if (temp.count > 0) {
        GDataXMLElement *temp = (GDataXMLElement *)[temp objectAtIndex:0];
        forecastData.temp = temp.stringValue;   // add .intValue to retrieve 
    }
    */
    /*
    // Fetch a STRING from an XML Node via XPATH & Add it to Dictionary with Key & Value
     NSArray *Array = [doc nodesForXPath:@"//response/current_observation/" error:nil];
     if (Array.count > 0) {
     GDataXMLElement *tempValue = (GDataXMLElement *)[Array objectAtIndex:0];
     [forecastData.detailDictionary setValue:tempValue.stringValue forKey:@""]; 
     }

     */
    
    // TESTER - use to see what we get back...
    //NSLog(@"RESPONSE ::\n%@",forecastData.detailDictionary);
    //NSLog(@"%@",forecastData);
    
    // REMOVED because it was re-saving locally loaded data and would never allow the file to expire because it was refreshed
    //[self saveWeatherDataToDisk:xmlData];
    //NSLog(@"XML DATA :: %@",xmlData);
    
    return forecastData;
}


@end
