//
//  AppDelegate.h
//  WeatherXML
//
//  Created by George Uno on 3/7/12.
//  Copyright (c) 2012 Kuawa Road Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@class ForecastDataModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    // ivars
    ForecastDataModel *_forecastData;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (nonatomic, strong) ForecastDataModel *forecastData;

@end
