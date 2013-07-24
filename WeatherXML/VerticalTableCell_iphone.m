//
//  VerticalTableCell_iphone.m
//  HorizontalTableViewsTest
//
//  Created by George Uno on 3/26/12.
//  Copyright (c) 2012 Kuawa Road Productions. All rights reserved.
//

#import "VerticalTableCell_iphone.h"
#import "Constants.h"
#import "DetailCell_iphone.h"
#import "DailyForecast.h"

@implementation VerticalTableCell_iphone

-(NSString *)reuseIdentifier
{
    return @"VerticalCell";
}

-(id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.horizontalTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCellHeight, kTableLength)] autorelease];
        self.horizontalTableView.showsVerticalScrollIndicator = NO;
        self.horizontalTableView.showsHorizontalScrollIndicator = NO;
        self.horizontalTableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
        [self.horizontalTableView setFrame:CGRectMake(kRowHorizontalPadding * 0.5, kRowVerticalPadding * 0.5, kTableLength-kRowHorizontalPadding, kCellHeight)];
        
        self.horizontalTableView.rowHeight = kCellWidth;
        self.horizontalTableView.backgroundColor = [UIColor clearColor];
        
        self.horizontalTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.horizontalTableView.separatorColor = [UIColor clearColor];
        
        self.horizontalTableView.allowsSelection = NO; //Blocks selection of the horizontal tableview cells!
        
        self.horizontalTableView.dataSource = self;
        self.horizontalTableView.delegate = self;
        
        [self addSubview:self.horizontalTableView];
    }
    
    return self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"DetailCell";
    
    DetailCell_iphone *cell = (DetailCell_iphone *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[[DetailCell_iphone alloc] initWithFrame:CGRectMake(0, 0, kCellWidth, kCellHeight)] autorelease];
    }
    
    //NSDictionary *currentArticle = [self.articles objectAtIndex:indexPath.row];
    
    DailyForecast *dailyForecast = [self.articles objectAtIndex:indexPath.row];
    
    cell.thumbnail.image = [UIImage imageNamed:dailyForecast.icon];
    
    cell.titleLabel.text = dailyForecast.conditions;//[NSString stringWithFormat:@"%@/%@:%@ - %@ (%i/%i)",dailyForecast.month,dailyForecast.day,dailyForecast.weekdayShort,dailyForecast.icon,dailyForecast.highF,dailyForecast.lowF];  //[self.articles objectAtIndex:indexPath.row];
    
    cell.dateLabel.text = [NSString stringWithFormat:@"%@ %@/%@",dailyForecast.weekdayShort,dailyForecast.month,dailyForecast.day];
    
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int comp = NSHourCalendarUnit;
    NSDateComponents *components = [calendar components:comp fromDate:date];
    
    if ([components hour] >= dailyForecast.sunriseHour && [components hour] <= dailyForecast.sunsetHour) {
        // SUN IS UP
        cell.sunOrMoonImage.image = [UIImage imageNamed:@"sun.png"];
    } else {
        cell.sunOrMoonImage.image = [UIImage imageNamed:@"moon.png"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"UnitsOfMeasure"] == 0) {
        cell.highLabel.text = [NSString stringWithFormat:@"%i°F",dailyForecast.highF];
        cell.lowLabel.text = [NSString stringWithFormat:@"%i°F",dailyForecast.lowF];
    } else {
        cell.highLabel.text = [NSString stringWithFormat:@"%i°C",dailyForecast.highC];
        cell.lowLabel.text = [NSString stringWithFormat:@"%i°C",dailyForecast.lowC];
    }
    
    [cell.highLabel setNeedsDisplay];
    [cell.lowLabel setNeedsDisplay];
    
    
    if (dailyForecast.precipPercent > 0) {
        NSMutableString *stringy = [NSMutableString stringWithString:[NSString stringWithFormat:@"%i",dailyForecast.precipPercent]];
        [stringy appendString:@"%"];
        cell.precipLabel.text = stringy;
        //cell.precipLabel.text = [NSString stringWithFormat:@"%i",dailyForecast.precipPercent];
        cell.precipLabel.hidden = NO;
    } else {
        cell.precipLabel.text = @"";
        cell.precipLabel.hidden = YES;
    }
    
    return cell;
}




@end
