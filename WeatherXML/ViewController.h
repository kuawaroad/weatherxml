//
//  ViewController.h
//  WeatherXML
//
//  Created by George Uno on 3/7/12.
//  Copyright (c) 2012 Kuawa Road Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionsScreen.h"

@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,OptionsScreenDelegate>

@property (nonatomic,retain) IBOutlet UITableView *futureTableView;
@property (nonatomic,retain) IBOutlet UIImageView *sunAndMoonImageView;
@property (nonatomic,retain) IBOutlet UIImageView *mainForecastImageView;

@property (nonatomic,strong) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) IBOutlet UILabel *cityLabel;
@property (nonatomic,strong) IBOutlet UILabel *zipCodeLabel;
@property (nonatomic,strong) IBOutlet UILabel *lowTempLabel;
@property (nonatomic,strong) IBOutlet UILabel *currentTempLabel;
@property (nonatomic,strong) IBOutlet UILabel *highTempLabel;
@property (nonatomic,strong) IBOutlet UILabel *forecastLabel;
@property (nonatomic,strong) IBOutlet UILabel *todaysDateLabel;

@property (nonatomic,assign) IBOutlet UIButton *locationButton;

- (IBAction)optionsButtonTapped;

@end
