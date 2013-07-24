//
//  VerticalTableCell.m
//  HorizontalTableViewsTest
//
//  Created by George Uno on 3/26/12.
//  Copyright (c) 2012 Kuawa Road Productions. All rights reserved.
//

#import "VerticalTableCell.h"
#import "Constants.h"

@implementation VerticalTableCell

@synthesize horizontalTableView = _horizontalTableView;
@synthesize articles = _articles;

#pragma mark Table View Data Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.articles count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"DetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    
    //cell.textLabel.text = @"EMBEDDED CELL";
    
    return cell;
}


-(void)dealloc {
    self.horizontalTableView = nil;
    self.articles = nil;
    
    [super dealloc];
}

@end
