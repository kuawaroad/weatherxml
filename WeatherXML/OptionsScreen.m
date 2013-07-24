//
//  OptionsScreen.m
//  WeatherXML
//
//  Created by George Uno on 3/27/12.
//  Copyright (c) 2012 Kuawa Road Productions. All rights reserved.
//

#import "OptionsScreen.h"
#import "GDataXMLNode.h"

@implementation OptionsScreen

@synthesize numberPadDoneImageNormal;
@synthesize numberPadDoneImageHighlighted;
@synthesize numberPadDoneButton;
@synthesize segmentSwitch;
@synthesize zipCodeField;
@synthesize delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.numberPadDoneImageNormal = [UIImage imageNamed:@"done-up.png"];
        self.numberPadDoneImageHighlighted = [UIImage imageNamed:@"done-down.png"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get current user zip and put in text field...
    int userUnits = [[NSUserDefaults standardUserDefaults] integerForKey:@"UnitsOfMeasure"];
    [self.segmentSwitch setSelectedSegmentIndex:userUnits];
    
    NSString *zipCodeString = [NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"UserZipCode"]];
    [self.zipCodeField setText:zipCodeString];
}

- (void)viewDidUnload
{
    [self setSegmentSwitch:nil];
    [self setZipCodeField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(BOOL)validateZipCode:(NSInteger)zipCode {
    return YES;
}


-(IBAction)saveButtonTapped:(id)sender {
    
    if ([zipCodeField.text integerValue] < 500 || zipCodeField.text.length < 5) {
        // Invalid Zipcode!
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Invalid Zip Code!" message:@"You entered an invalid zipcode, please enter another zip code." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
        [alertView show];
    } else {
        NSLog(@"Saving Changes !\n%@\n%i",zipCodeField.text, segmentSwitch.selectedSegmentIndex);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:[[zipCodeField text] integerValue] forKey:@"UserZipCode"];
        [defaults setInteger:[segmentSwitch selectedSegmentIndex] forKey:@"UnitsOfMeasure"];
        [defaults synchronize];
    
        [self.delegate optionsScreenDidSaveChanges];
    
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)creditsButtonTapped:(id)sender {
    
}


#pragma mark Number Pad Done Button!
/*
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    if ([super initWithNibName:nibName bundle:nibBundle] == nil)
        return nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.0) {
        self.numberPadDoneImageNormal = [UIImage imageNamed:@"NumberDone.png"];
        self.numberPadDoneImageHighlighted = [UIImage imageNamed:@"NumberDone.png"];
    } else {        
        self.numberPadDoneImageNormal = [UIImage imageNamed:@"NumberDone.png"];
        self.numberPadDoneImageHighlighted = [UIImage imageNamed:@"NumberDone.png"];
    }        
    return self;
}
*/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Add listener for keyboard display events
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardDidShow:) 
                                                     name:UIKeyboardDidShowNotification 
                                                   object:nil];     
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardWillShow:) 
                                                     name:UIKeyboardWillShowNotification 
                                                   object:nil];
    }
    
    // Add listener for all text fields starting to be edited
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(textFieldDidBeginEditing:)
                                                 name:UITextFieldTextDidBeginEditingNotification 
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
        [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                        name:UIKeyboardDidShowNotification 
                                                      object:nil];      
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                        name:UIKeyboardWillShowNotification 
                                                      object:nil];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UITextFieldTextDidBeginEditingNotification 
                                                  object:nil];
    [super viewWillDisappear:animated];
}

- (UIView *)findFirstResponderUnder:(UIView *)root {
    if (root.isFirstResponder)
        return root;    
    for (UIView *subView in root.subviews) {
        UIView *firstResponder = [self findFirstResponderUnder:subView];        
        if (firstResponder != nil)
            return firstResponder;
    }
    return nil;
}

- (UITextField *)findFirstResponderTextField {
    UIResponder *firstResponder = [self findFirstResponderUnder:[self.view window]];
    if (![firstResponder isKindOfClass:[UITextField class]])
        return nil;
    return (UITextField *)firstResponder;
}

- (void)updateKeyboardButtonFor:(UITextField *)textField {
    
    // Remove any previous button
    [self.numberPadDoneButton removeFromSuperview];
    self.numberPadDoneButton = nil;
    
    // Does the text field use a number pad?
    if (textField.keyboardType != UIKeyboardTypeNumberPad)
        return;
    
    // If there's no keyboard yet, don't do anything
    if ([[[UIApplication sharedApplication] windows] count] < 2)
        return;
    UIWindow *keyboardWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    
    // Create new custom button
    self.numberPadDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.numberPadDoneButton.frame = CGRectMake(0, 163, 106, 53);
    self.numberPadDoneButton.adjustsImageWhenHighlighted = FALSE;
    [self.numberPadDoneButton setTitle:@"Return" forState:UIControlStateNormal];
    //[self.numberPadDoneButton setFont:[UIFont boldSystemFontOfSize:18]];
    [self.numberPadDoneButton setTitleColor:[UIColor colorWithRed:77.0f/255.0f green:84.0f/255.0f blue:98.0f/255.0f alpha:1.0] forState:UIControlStateNormal];  
    
    [self.numberPadDoneButton setImage:self.numberPadDoneImageNormal forState:UIControlStateNormal];
    [self.numberPadDoneButton setImage:self.numberPadDoneImageHighlighted forState:UIControlStateHighlighted];
    [self.numberPadDoneButton addTarget:self action:@selector(numberPadDoneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // Locate keyboard view and add button
    NSString *keyboardPrefix = [[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2 ? @"<UIPeripheralHost" : @"<UIKeyboard";
    for (UIView *subView in keyboardWindow.subviews) {
        if ([[subView description] hasPrefix:keyboardPrefix]) {
            [subView addSubview:self.numberPadDoneButton];
            [self.numberPadDoneButton addTarget:self action:@selector(numberPadDoneButton:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
    }
}

- (void)textFieldDidBeginEditing:(NSNotification *)note {
    [self updateKeyboardButtonFor:[note object]];
}

- (void)keyboardWillShow:(NSNotification *)note {
    [self updateKeyboardButtonFor:[self findFirstResponderTextField]];
}

- (void)keyboardDidShow:(NSNotification *)note {
    [self updateKeyboardButtonFor:[self findFirstResponderTextField]];
}

- (IBAction)numberPadDoneButton:(id)sender {
    
    if ([zipCodeField.text integerValue] < 500 || zipCodeField.text.length < 5) {
        // Invalid Zipcode!
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Invalid Zip Code!" message:@"You entered an invalid zipcode, please enter another zip code." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
        [alertView show];
        
    } else {
        NSLog(@"Saving Changes !\n%@\n%i",zipCodeField.text, segmentSwitch.selectedSegmentIndex);
        UITextField *textField = [self findFirstResponderTextField];
        [textField resignFirstResponder];
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:[[zipCodeField text] integerValue] forKey:@"UserZipCode"];
        [defaults setInteger:[segmentSwitch selectedSegmentIndex] forKey:@"UnitsOfMeasure"];
        [defaults synchronize];
    
        [self.delegate optionsScreenDidSaveChanges];
    
        [self dismissModalViewControllerAnimated:YES];
    }
}


- (void)dealloc {
    [numberPadDoneImageNormal release];
    [numberPadDoneImageHighlighted release];
    [numberPadDoneButton release];
    [segmentSwitch release];
    [zipCodeField release];
    self.delegate = nil;
    
    [super dealloc];
}


@end
