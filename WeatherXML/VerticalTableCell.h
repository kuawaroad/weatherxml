//
//  VerticalTableCell.h
//  HorizontalTableViewsTest
//
//  Created by George Uno on 3/26/12.
//  Copyright (c) 2012 Kuawa Road Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerticalTableCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_horizontalTableView;
    NSMutableArray *_articles;
}

@property (nonatomic,retain) UITableView *horizontalTableView;
@property (nonatomic,retain) NSMutableArray *articles;

@end
