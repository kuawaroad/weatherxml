//
//  Constants.h
//  HoriztonalTables
//
//  Created by George Uno on 2/27/12.
//  Copyright (c) 2012 Kuawa Road Productions. All rights reserved.
//

// iPhone Constants

// The Width of the Horizontal table view (pre-rotation = table view length)
#define kTableLength 320 // Auto resizes to 640 for retina displays

// Width of the embedded tableView's cells after rotation (pre-rotation = rowHeight)
#define kCellWidth 106

//Height of the Horizontal table views cells after rotation (pre-rotate = tableView||cell width
#define kCellHeight 175 // was 140

// Padding for the Horizontal?? Cell containing the article & image
#define kArticleCellVerticalInnerPadding 3
#define kArticleCellHorizontalInnerPadding 3

// Padding for the title label in an article / horizontal cell
#define kArticleTitleLabelPadding 4

// Padding for the horizontal table view within the vertical table views rows
#define kRowVerticalPadding 0
#define kRowHorizontalPadding 0

// BG Color for Vertical Table View
#define kVerticalTableBackgroundColor [UIColor colorWithRed:0.58823529 green:0.58823529 blue:0.5823529 alpha:1.0]

// BG Color for Horizontal table view (embedded tableview)
#define kHorizontalTableBackgroundColor [UIColor colorWithRed:0.6745098 green:0.6745098 blue:0.6745098 alpha:1.0]

// Selected BG Color for Horizontal TableView (vertical table view never selected)      GREENISH
#define kHorizontalTableSelectedBackgroundColor [UIColor lightGrayColor];//[UIColor colorWithRed:0.0 green:0.59607843 blue:0.37254902 alpha:1.0]


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// iPad CONSTANTS
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Width (or length before rotation) of the table view embedded within another table view's row
#define kTableLength_iPad                               768

// Height for the Headlines section of the main (vertical) table view
#define kHeadlinesSectionHeight_iPad                    65

// Height for regular sections in the main table view
#define kRegularSectionHeight_iPad                      36

// Width of the cells of the embedded table view (after rotation, which means it controls the rowHeight property)
#define kCellWidth_iPad                                 226
// Height of the cells of the embedded table view (after rotation, which would be the table's width)
#define kCellHeight_iPad                                226

// Padding for the Cell containing the article image and title
#define kArticleCellVerticalInnerPadding_iPad           4
#define kArticleCellHorizontalInnerPadding_iPad         4

// Vertical padding for the embedded table view within the row
#define kRowVerticalPadding_iPad                        0
// Horizontal padding for the embedded table view within the row
#define kRowHorizontalPadding_iPad                      0

// UI COLOR SCHEME
#define kNavBarColor [UIColor colorWithRed: 125/255.0 green: 125/255.0 blue: 125/255.0 alpha:1.0];

#define kHeaderColor [UIColor colorWithRed: 125/255.0 green: 125/255.0 blue: 125/255.0 alpha:1.0];

#define kArticleBoxColor [UIColor colorWithRed: 125/255.0 green: 125/255.0 blue: 125/255.0 alpha:1.0];

#define kHeaderTextColor [UIColor colorWithRed: 125/255.0 green: 125/255.0 blue: 125/255.0 alpha:1.0];
#define kLabelTextColor [UIColor colorWithRed: 125/255.0 green: 125/255.0 blue: 125/255.0 alpha:1.0];
