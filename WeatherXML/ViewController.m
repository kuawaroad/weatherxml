//
//  ViewController.m
//  WeatherXML
//
//  Created by George Uno on 3/7/12.
//  Copyright (c) 2012 Kuawa Road Productions. All rights reserved.
//


#import "ViewController.h"
#import "GDataXMLNode.h"
#import "WeatherReader.h"
#import "ForecastDataModel.h"
#import "DailyForecast.h"
#import "Constants.h"
#import "VerticalTableCell_iphone.h"
#import "OptionsScreen.h"

@implementation ViewController {
    // iVars
    ForecastDataModel *loadedData;
}

@synthesize futureTableView,mainForecastImageView,sunAndMoonImageView, locationButton;
@synthesize timeLabel, cityLabel, zipCodeLabel, lowTempLabel, currentTempLabel, highTempLabel, forecastLabel, todaysDateLabel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)updateUserInterface {
    //self.timeLabel.text = ; Move to clock function?
    //self.todaysDateLabel.text = ; Move to clock function?
    // ° COPY PASTE DEGREE SIGN
    
    self.cityLabel.text = [NSString stringWithFormat:@"%@ %@",loadedData.locationFull,loadedData.locationZip];
    DailyForecast *todaysForecast = [loadedData.tenDayArray objectAtIndex:0];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"UnitsOfMeasure"] == 0) {
        NSLog(@"Displaying FAHRENHEIT");
        self.currentTempLabel.text = [NSString stringWithFormat:@"%i°F",loadedData.currentTempFahrenheit];
        self.lowTempLabel.text = [NSString stringWithFormat:@"%i°F",todaysForecast.lowF];
        self.highTempLabel.text = [NSString stringWithFormat:@"%i°F",todaysForecast.highF];
    } else {
        NSLog(@"Displaying CELSIUS");
        self.currentTempLabel.text = [NSString stringWithFormat:@"%i°C",loadedData.currentTempCelsius];
        self.lowTempLabel.text = [NSString stringWithFormat:@"%i°C",todaysForecast.lowC];
        self.highTempLabel.text = [NSString stringWithFormat:@"%i°C",todaysForecast.highC];
    }
    
    // Current Conditions String
    self.forecastLabel.text = loadedData.weather;
    
    //main forecast image to show animation...
    self.mainForecastImageView.image = [UIImage imageNamed:loadedData.iconName];
    NSLog(@"DISPLAYING :: %@",loadedData.iconName);
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int comp = NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:comp fromDate:date];
    NSLog(@"CURRENT TIME :: HOURS:%i   MINUTES:%i",[components hour],[components minute]);
    
    
    // IF >= sunrise && <= sunset SUN // IF > sunset || < sunrise SHOW MOON
    int sunriseHour = [[loadedData.detailDictionary valueForKey:@"sunriseHour"] integerValue];
    //int sunriseMinute = [[loadedData.detailDictionary valueForKey:@"sunriseMinute"] integerValue];
    int sunsetHour = [[loadedData.detailDictionary valueForKey:@"sunsetHour"] integerValue];
    //int sunsetMinute = [[loadedData.detailDictionary valueForKey:@"sunsetMinute"] integerValue];
    int nowHour = [components hour];
    //int nowMinute = [components minute];
    
    if (nowHour >= sunriseHour && nowHour <= sunsetHour) {
        // it's daytime
        NSLog(@"DAY TIME!");
        self.sunAndMoonImageView.image = [UIImage imageNamed:@"sun.png"];
    } else if (nowHour > sunsetHour || nowHour < sunriseHour) {
        NSLog(@"NIGHT TIME!");
        self.sunAndMoonImageView.image = [UIImage imageNamed:@"moon.png"];
    }
    
    NSLog(@"\nSUNRISE :: %i:%i\nSUNSET :: %i:%i",[[loadedData.detailDictionary valueForKey:@"sunriseHour"] integerValue],[[loadedData.detailDictionary valueForKey:@"sunriseMinute"] integerValue],[[loadedData.detailDictionary valueForKey:@"sunsetHour"] integerValue],[[loadedData.detailDictionary valueForKey:@"sunsetMinute"]integerValue]);
}

-(void)updateTimeAndDate {
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.todaysDateLabel.text = [dateFormatter stringFromDate:today];
    
    /*
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateStyle:NSDateFormatterNoStyle];
    [timeFormatter setTimeStyle:NSDateFormatterMediumStyle];
    self.timeLabel.text = [timeFormatter stringFromDate:today];
     */
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"ViewDidLoad...");
	// Do any additional setup after loading the view, typically from a nib.
    // Register the default zipcode with NSUserDefaults
    NSDictionary *defaultDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:83843],@"UserZipCode",  // default zipcode
                                       [NSNumber numberWithInt:0],@"UnitsOfMeasure",  // 0 = USA 1 = metric
                                       [NSNumber numberWithBool:YES],@"PlaySFX", // Yes plays sfx, NO is silent
                                       nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultDictionary];
    NSLog(@"DEFAULT ZIP %i",[[NSUserDefaults standardUserDefaults] integerForKey:@"UserZipCode"]);
    
    NSInteger userZip = [[NSUserDefaults standardUserDefaults] integerForKey:@"UserZipCode"];
    NSString *userZipString = [NSString stringWithFormat:@"%i",userZip];
    
    if (userZip <= 500 || userZipString.length < 5 || userZip == 82283) { 
        NSLog(@"INVALID ZIP!");
        NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
        [myDefaults setInteger:96734 forKey:@"UserZipCode"];
        [myDefaults synchronize];
    }
    
    //WeatherReader *xmlParser = [[[WeatherReader alloc] init] autorelease];
    loadedData = [WeatherReader loadForecastData];
    //NSLog(@"ViewController Forecast::%@",loadedData);
    [loadedData retain];  // MUST CALL RETAIN OR THE DATA ISN'T PERSISTED THROUGHOUT CLASS!!!!  Caused tableView scroll crash!
    
    
    // Manipulate the Parent Table View
    self.futureTableView.backgroundColor = [UIColor clearColor];
    self.futureTableView.scrollEnabled = NO;
    self.futureTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // schedule Time & Date refreshing every 6 seconds
    [self updateTimeAndDate];
    [self updateUserInterface];
    
    [NSTimer scheduledTimerWithTimeInterval:900.0 target:self selector:@selector(updateUserInterface) userInfo:nil repeats:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}
 */

#pragma mark UITableView Delegate & Data Source Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;//[loadedData.tenDayArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VerticalCell";
    
    VerticalTableCell_iphone *cell = (VerticalTableCell_iphone *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[VerticalTableCell_iphone alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height)] autorelease];
    }
    
    // must give articles objects or count == 0 and no embedded cells are created.
    cell.articles = loadedData.tenDayArray; //[[[NSArray alloc] initWithObjects:@"One",@"Two",@"Three",@"Four",@"Five", nil] autorelease];
    
    return cell;
    
}

-(void)awakeFromNib
{
    [self.futureTableView setBackgroundColor:kVerticalTableBackgroundColor];
    self.futureTableView.rowHeight = kCellHeight + (kRowVerticalPadding * 0.5) + ((kRowVerticalPadding * 0.5) * 0.5);
}

/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Selected Row @ Index Path!
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
*/

- (IBAction)optionsButtonTapped
{
    OptionsScreen *optionsVC = [[[OptionsScreen alloc] initWithNibName:@"OptionsScreen_iPhone" bundle:nil] autorelease];
    optionsVC.delegate = self;
    [self presentModalViewController:optionsVC animated:YES];
    /***
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        NSLog(@"Options Button Pressed... iPhone");
        OptionsScreen *optionsVC = [[[OptionsScreen alloc] initWithNibName:@"OptionsScreen_iPhone" bundle:nil] autorelease];
        optionsVC.delegate = self;
        [self presentModalViewController:optionsVC animated:YES];
    } else {
        NSLog(@"Options Button Pressed... iPAD");
        OptionsScreen *optionsVCiPad = [[[OptionsScreen alloc] initWithNibName:@"OptionsScreen_iPad" bundle:nil] autorelease];
        [self presentModalViewController:optionsVCiPad animated:YES];
    }
     ***/
    
}

-(void)optionsScreenDidSaveChanges
{
    loadedData = [WeatherReader loadForecastData];
    [loadedData retain];
    [self updateTimeAndDate];
    [self updateUserInterface];
    [self.futureTableView reloadData];
    //[self.futureTableView setNeedsLayout];
    [self.futureTableView setNeedsDisplay];
}

-(void)dealloc {
    self.futureTableView = nil;
    self.sunAndMoonImageView = nil;
    self.mainForecastImageView = nil;
    self.timeLabel = nil;
    self.cityLabel = nil;
    self.zipCodeLabel = nil;
    self.lowTempLabel = nil;
    self.highTempLabel = nil;
    self.currentTempLabel = nil;
    self.forecastLabel = nil;
    self.todaysDateLabel = nil;
    self.locationButton = nil;
    [loadedData release];
    [super dealloc];
}

@end
