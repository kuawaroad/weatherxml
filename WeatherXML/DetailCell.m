//
//  DetailCell.m
//  HorizontalTableViewsTest
//
//  Created by George Uno on 3/26/12.
//  Copyright (c) 2012 Kuawa Road Productions. All rights reserved.
//

#import "DetailCell.h"

@implementation DetailCell

@synthesize thumbnail = _thumbnail;
@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;
@synthesize precipLabel = _precipLabel;
@synthesize highLabel = _highLabel;
@synthesize lowLabel = _lowLabel;
@synthesize sunOrMoonImage = _sunOrMoonImage;

-(NSString *)reuseIdentifier
{
    return @"DetailCell";
}


-(void)dealloc
{
    self.thumbnail = nil;
    self.titleLabel = nil;
    self.dateLabel = nil;
    self.precipLabel = nil;
    self.highLabel = nil;
    self.lowLabel = nil;
    self.sunOrMoonImage = nil;
    [super dealloc];
}


@end
