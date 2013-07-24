//
//  OptionsScreen.h
//  WeatherXML
//
//  Created by George Uno on 3/27/12.
//  Copyright (c) 2012 Kuawa Road Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

// DELEGATE PROTOCOL METHODS
@protocol OptionsScreenDelegate <NSObject>
-(void)optionsScreenDidSaveChanges;
@end

@interface OptionsScreen : UIViewController
{     //iVars
    UIImage *numberPadDoneImageNormal;
    UIImage *numberPadDoneImageHighlighted;
    UIButton *numberPadDoneButton;
    
    
}
@property (nonatomic,strong) id <OptionsScreenDelegate> delegate;

@property (nonatomic, retain) UIImage *numberPadDoneImageNormal;
@property (nonatomic, retain) UIImage *numberPadDoneImageHighlighted;
@property (nonatomic, retain) UIButton *numberPadDoneButton;

@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentSwitch;
@property (retain, nonatomic) IBOutlet UITextField *zipCodeField;


- (IBAction)numberPadDoneButton:(id)sender;


- (IBAction)saveButtonTapped:(id)sender;
- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)creditsButtonTapped:(id)sender;

@end
