//
//  EGRCalculatorViewController.m
//  EGRCalculator
//
//  Created by Niklas Nordin on 2011-12-03.
//  Copyright (c) 2011 nequam. All rights reserved.
//

#import "EGRCalculatorViewController.h"
#import "EGRCompositionVC.h"

#define offset 1.1

@interface EGRCalculatorViewController()
@property (nonatomic) NSInteger textFieldY;
@property (nonatomic) BOOL keyboardVisible;
@property (nonatomic) NSInteger keyboardHeight;
@end

@implementation EGRCalculatorViewController

@synthesize egrCalc = _egrCalc;
@synthesize cnText = _cnText;
@synthesize cmText = _cmText;
@synthesize crText = _crText;
@synthesize lambaText = _lambaText;
@synthesize egrText = _egrText;
@synthesize o2Text = _o2Text;
@synthesize n2Text = _n2Text;
@synthesize textFieldY = _textFieldY;
@synthesize keyboardVisible = _keyboardVisible;
@synthesize keyboardHeight = _keyboardHeight;

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder]; 
    return YES;
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
	[self.cnText resignFirstResponder];
    [self.cmText resignFirstResponder];
    [self.crText resignFirstResponder];
}
*/

-(void) keyboardDidShow: (NSNotification *)notif 
{
    if (self.keyboardVisible) 
    {
        //NSLog(@"Keyboard is already visible. Ignoring notification.");
        return;
    }
    
    // Get the size of the keyboard.
    NSDictionary* info = [notif userInfo];
    NSValue *aValue = info[UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    self.keyboardHeight = keyboardSize.height;
    
    NSInteger dY = self.textFieldY - self.keyboardHeight;
    if (dY > 0)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - dY), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }

    // Keyboard is now visible
    self.keyboardVisible = YES;
}

-(void) keyboardDidHide: (NSNotification *)notif 
{
    // Is the keyboard already shown
    if (!self.keyboardVisible) 
    {
        //NSLog(@"Keyboard is already hidden. Ignoring notification.");
        return;
    }
   
    NSInteger dY = self.textFieldY - self.keyboardHeight;
    
    if (dY > 0)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + dY, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }

    self.keyboardVisible = NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField 
{	
    NSInteger curY = textField.frame.origin.y + textField.frame.size.height*offset;

    if (self.keyboardVisible)
    {        
        NSInteger dY1 = self.textFieldY - self.keyboardHeight;
        
        // first reverse the previous slide
        if (dY1 > 0)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.2];
            [UIView setAnimationBeginsFromCurrentState:YES];

            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + dY1, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
        }
        
        // then create the new slide
        NSInteger dY2 = curY - self.keyboardHeight;
        if (dY2 > 0)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.2];
            [UIView setAnimationBeginsFromCurrentState:YES];
            
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - dY2, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
        }
    }

    self.textFieldY = curY;

}

- (void)textFieldDidEndEditing:(UITextField *)textField 
{
    if ([self.lambaText.text doubleValue] < 1)
        self.lambaText.text = @"1.0";
    
    if ([self.egrText.text doubleValue] < 0)
        self.egrText.text = @"0.0";
    
    if ([self.egrText.text doubleValue] > 100)
        self.egrText.text = @"100.0";         
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyboardDidShow:)
                                                 name: UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector (keyboardDidHide:)
                                                 name: UIKeyboardDidHideNotification object:nil];
    [super viewDidLoad];    
}

- (void)viewDidUnload 
{
    [self setCnText:nil];
    [self setCmText:nil];
    [self setCrText:nil];
    [self setLambaText:nil];
    [self setEgrText:nil];
    [self setO2Text:nil];
    [self setN2Text:nil];
    [super viewDidUnload];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // This is the place to setup the view before displaying it
    if ([segue.identifier isEqualToString:@"ShowComposition"])
    {
        [segue.destinationViewController setEgrCalc:self.egrCalc];
    }
}


- (IBAction)calculateButton:(id)sender 
{
    self.egrCalc = [[EGRCalculator alloc] initWithLambda:self.lambaText.text egr:self.egrText.text cn:self.cnText.text cm:self.cmText.text cr:self.crText.text oxygen:self.o2Text.text nitro:self.n2Text.text];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2];
    [banner setAlpha:1];
    [UIView commitAnimations];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2];
    [banner setAlpha:0];
    [UIView commitAnimations];
}
@end
