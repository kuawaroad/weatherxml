//
//  DetailCell.h
//  HorizontalTableViewsTest
//
//  Created by George Uno on 3/26/12.
//  Copyright (c) 2012 Kuawa Road Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCell : UITableViewCell
{
    UIImageView *_thumbnail;
    UIImageView *_sunOrMoonImage;
    UILabel *_titleLabel;
    UILabel *_dateLabel;
    UILabel *_precipLabel;
    UILabel *_highLabel;
    UILabel *_lowLabel;
}

@property (nonatomic,retain) UIImageView *thumbnail;
@property (nonatomic,retain) UILabel *dateLabel;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *precipLabel;
@property (nonatomic,retain) UILabel *highLabel;
@property (nonatomic,retain) UILabel *lowLabel;
@property (nonatomic,retain) UIImageView *sunOrMoonImage;
@end
