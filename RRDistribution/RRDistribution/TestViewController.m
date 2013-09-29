//
//  TestViewController.m
//  RRDistribution
//
//  Created by Niklas Nordin on 2013-09-28.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()
@property (nonatomic) int iterationIndex;
@end

@implementation TestViewController

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
    _nSamplesTextField.delegate = self;
    _lambdaTextField.delegate = self;
    _kTextField.delegate = self;
    [self.iterationLabel setText:@"kalle"];
    //[self.tabBarController]
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pasteButtonPressed:(id)sender
{
    NSLog(@"paste pressed");
}

- (IBAction)TestButtonPressed:(id)sender
{
    //[self runIterations];
    [self performSelectorInBackground:@selector(runIterations) withObject:nil];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)runIterations
{
    //NSLog(@"iterations = %d",iterations);
    //float smd = 0.0;
    //float dv90 = 0.0;
    self.iterationIndex = 1;
    
    [self updateIteration:self.iterationIndex];

}

- (void)updateIteration:(int)i
{
    float f = [self.function sample:i];

    NSString *labelText = [NSString stringWithFormat:@"%d", i];
    NSLog(@"labeltText = %@",labelText);
    self.iterationLabel.text = labelText;
    [self.view setNeedsDisplayInRect:self.iterationLabel.frame];
    self.iterationIndex = i+1;
    int iterations = [[self.nSamplesTextField text] intValue];

    if (self.iterationIndex <= iterations)
    {
        //usleep(100000);
        [self updateIteration:self.iterationIndex];
    }
}

@end
