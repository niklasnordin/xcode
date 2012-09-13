//
//  equationViewController.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-24.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "equationViewController.h"

@interface equationViewController ()

@end

@implementation equationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    NSString *name = [_functionNames objectAtIndex:_functionIndex];
    NSString *fullName = [NSString stringWithFormat:@"%@.png",name];
    
    UIImage *im = [UIImage imageNamed:fullName];
    [_image setContentMode:UIViewContentModeScaleAspectFit];
    [_image setImage:im];
    
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    [self.view addGestureRecognizer:swipeRightRecognizer];
    //[self.view addGestureRecognizer:panRecognizer];
    
}

- (void)viewDidUnload
{
    [self setImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)swipeGesture:(UISwipeGestureRecognizer *)gesture
{
    int numberOfNames = [_functionNames count];
    
    [UIView beginAnimations:@"flip" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        _functionIndex++;
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    }

    if (gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        _functionIndex--;
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    }
    
    if (_functionIndex < 0)
    {
        _functionIndex = numberOfNames-1;
    }
    if (_functionIndex == numberOfNames)
    {
        _functionIndex = 0;
    }


    NSString *name = [_functionNames objectAtIndex:_functionIndex];
    NSString *fullName = [NSString stringWithFormat:@"%@.png",name];
    
    UIImage *im = [UIImage imageNamed:fullName];
    //[_image setContentMode:UIViewContentModeScaleAspectFit];
    [_image setImage:im];
    [UIView commitAnimations];
    [self setTitle:name];
    /*
    [_spVC setCurrentRow:_functionIndex];
    [_spVC.picker selectRow:_functionIndex inComponent:0 animated:NO];
    [_spVC.functionButton setTitle:name forState:UIControlStateNormal];
    [_spVC setNewFunction:name];
     */
    
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    NSLog(@"pan");
}

- (IBAction)setEquationPressed:(id)sender
{
    NSString *name = [_functionNames objectAtIndex:_functionIndex];

    [_spVC setCurrentRow:_functionIndex];
    [_spVC.picker selectRow:_functionIndex inComponent:0 animated:NO];
    [_spVC.functionButton setTitle:name forState:UIControlStateNormal];
    [_spVC setNewFunction:name];
}


@end
