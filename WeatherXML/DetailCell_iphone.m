//
//  DetailCell_iphone.m
//  HorizontalTableViewsTest
//
//  Created by George Uno on 3/26/12.
//  Copyright (c) 2012 Kuawa Road Productions. All rights reserved.
//

#import "DetailCell_iphone.h"
#import "Constants.h"

@implementation DetailCell_iphone

-(id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
        self.sunOrMoonImage = [[[UIImageView alloc] initWithFrame:CGRectMake(kArticleCellHorizontalInnerPadding, kCellHeight/5, kCellWidth - (kArticleCellHorizontalInnerPadding *2), kCellHeight/2)] autorelease];
        self.sunOrMoonImage.opaque = YES;
        self.sunOrMoonImage.contentMode = UIViewContentModeScaleAspectFit;
        self.sunOrMoonImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.sunOrMoonImage];
    
        self.thumbnail = [[[UIImageView alloc] initWithFrame:CGRectMake(kArticleCellHorizontalInnerPadding, -5, kCellWidth - (kArticleCellHorizontalInnerPadding * 2), kCellHeight - (kArticleCellVerticalInnerPadding * 2))] autorelease];
                           //initWithFrame:CGRectMake(kArticleCellHorizontalInnerPadding, kArticleCellVerticalInnerPadding, kCellWidth - (kArticleCellHorizontalInnerPadding*2), kCellHeight - (kArticleCellVerticalInnerPadding*2))] autorelease];
        self.thumbnail.opaque = NO;
        self.thumbnail.contentMode = UIViewContentModeScaleAspectFit;
        self.thumbnail.backgroundColor = [UIColor colorWithRed:100 green:100 blue:100 alpha:0.1]; //[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
        [self.contentView addSubview:self.thumbnail]; // add as subview of cell's CONTENT VIEW not just subview of the cell...
        
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kArticleCellHorizontalInnerPadding, self.thumbnail.frame.size.height * 0.70 + kArticleCellVerticalInnerPadding, self.thumbnail.frame.size.width, self.thumbnail.frame.size.height * 0.25)] autorelease];
        self.titleLabel.backgroundColor = [UIColor colorWithRed:100 green:100 blue:100 alpha:0.2];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.minimumFontSize = 10.0;
        [self.contentView addSubview:self.titleLabel]; // now we add labels as subviews of the thumbnails view... why not contentview?
        
        
        self.dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kArticleCellHorizontalInnerPadding, 0, self.thumbnail.frame.size.width, self.thumbnail.frame.size.height * 0.20)] autorelease]; 
        self.dateLabel.backgroundColor = [UIColor colorWithRed:100 green:100 blue:100 alpha:0.2];
        self.dateLabel.textColor = [UIColor whiteColor];
        self.dateLabel.textAlignment = UITextAlignmentCenter;
        self.dateLabel.font = [UIFont boldSystemFontOfSize:16.0];
        self.dateLabel.numberOfLines = 2;
        [self.contentView addSubview:self.dateLabel];
        
        self.precipLabel = [[[UILabel alloc] initWithFrame:CGRectMake(self.thumbnail.frame.size.width * 0.6 + kArticleCellHorizontalInnerPadding, self.thumbnail.frame.size.height * 0.60 + kArticleCellVerticalInnerPadding, self.thumbnail.frame.size.width * 0.4, self.thumbnail.frame.size.height * 0.1)] autorelease];
        self.precipLabel.backgroundColor = [UIColor clearColor];
        self.precipLabel.textColor = [UIColor whiteColor];
        self.precipLabel.textAlignment = UITextAlignmentRight;
        self.precipLabel.font = [UIFont systemFontOfSize:14.0];
        self.precipLabel.numberOfLines = 1;
        [self.contentView addSubview:self.precipLabel];
        
        self.lowLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kArticleCellHorizontalInnerPadding, self.thumbnail.frame.size.height * .18 + kArticleCellVerticalInnerPadding, self.thumbnail.frame.size.width * .4, self.thumbnail.frame.size.height * .1)] autorelease];
        self.lowLabel.backgroundColor = [UIColor clearColor];
        self.lowLabel.textColor = [UIColor blueColor];
        self.lowLabel.textAlignment = UITextAlignmentLeft;
        self.lowLabel.font = [UIFont boldSystemFontOfSize:14.0];
        self.lowLabel.numberOfLines = 1;
        [self.contentView addSubview:self.lowLabel];
        
        self.highLabel = [[[UILabel alloc] initWithFrame:CGRectMake(self.thumbnail.frame.size.width * .6 +kArticleCellHorizontalInnerPadding, self.thumbnail.frame.size.height * .18 + kArticleCellVerticalInnerPadding, self.thumbnail.frame.size.width * .4, self.thumbnail.frame.size.height * .1)] autorelease];
        self.highLabel.backgroundColor = [UIColor clearColor];
        self.highLabel.textColor = [UIColor redColor];
        self.highLabel.textAlignment = UITextAlignmentRight;
        self.highLabel.font = [UIFont boldSystemFontOfSize:14.0];
        self.highLabel.numberOfLines = 1;
        [self.contentView addSubview:self.highLabel];
        
        self.backgroundColor = [UIColor purpleColor];
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:self.thumbnail.frame] autorelease];
        self.selectedBackgroundView.backgroundColor = [UIColor purpleColor];
        
        self.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    
    }
    
    return self;
}

@end
