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
    im = nil;
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    [self.view addGestureRecognizer:swipeRightRecognizer];
    //[self.view addGestureRecognizer:panRecognizer];
    //[self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];

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

- (void)animateLeft
{
    int numberOfNames = (int)[_functionNames count];

    _functionIndex++;
    if (_functionIndex == numberOfNames)
    {
        _functionIndex = 0;
    }

    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:NO];
 
}

- (void)animateRight
{
    int numberOfNames = (int)[_functionNames count];

    _functionIndex--;
    if (_functionIndex < 0)
    {
        _functionIndex = numberOfNames-1;
    }
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:NO];
    //[UIView setAnimationTransition:UIViewAnimationCurveEaseInOut forView:self.view cache:YES];

}

- (void)swipeGesture:(UISwipeGestureRecognizer *)gesture
{
    
    [UIView beginAnimations:@"flip" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self animateLeft];
    }

    if (gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self animateRight];
    }

    NSString *name = [_functionNames objectAtIndex:_functionIndex];
    NSString *fullName = [NSString stringWithFormat:@"%@.png",name];

    UIImage *im = [UIImage imageNamed:fullName];

    [_image setImage:im];
    [UIView commitAnimations];
    [self setTitle:name];
    //free(im);
    im = nil;
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    //NSLog(@"pan");
    CGPoint pan;
    CGPoint zero;
    zero.x = 0.0;
    zero.y = 0.0;
    
    BOOL animate = NO;
    
    if
    (
        (gesture.state == UIGestureRecognizerStateChanged)
            //||
            //(gesture.state == UIGestureRecognizerStateEnded)
    )
    {
        pan = [gesture translationInView:self.view];
        CGPoint vr = self.view.center;
        vr.x += pan.x;        
        [gesture setTranslation:zero inView:self.view];
        [self.view setCenter:vr];
        CGFloat xc = self.view.bounds.size.width/2.0;

        if (fabs(xc-vr.x)>50)
        {
            animate = YES;
        }
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"ended");
        animate = YES;

    }
    
    if (animate)
    {
        CGPoint center = self.view.center;
        CGFloat xc = self.view.bounds.size.width/2.0;
        
        [UIView beginAnimations:@"flip" context:nil];
        [UIView setAnimationDuration:0.6];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        
        if (center.x > xc)
        {
            [self animateRight];
        }
        else
        {
            [self animateLeft];
        }
        
        NSString *name = [_functionNames objectAtIndex:_functionIndex];
        NSString *fullName = [NSString stringWithFormat:@"%@.png",name];
        
        UIImage *im = [UIImage imageNamed:fullName];
        //[_image setContentMode:UIViewContentModeScaleAspectFit];
        [_image setImage:im];
        [UIView commitAnimations];
        center.x = xc;
        [self.view setCenter:center];
        
        [self setTitle:name];
        //[[self navigationItem] titleView] set
    }
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
