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
@property (strong, nonatomic) NSTimer *timer;
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
    //[self performSelectorInBackground:@selector(runIterations) withObject:nil];
    self.iterationIndex = 1;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(runIterations) userInfo:nil repeats:YES];
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
    NSString *labelText = [NSString stringWithFormat:@"%d", self.iterationIndex];
    [self.iterationLabel setText:labelText];

    self.iterationIndex = self.iterationIndex + 1;
    if (self.iterationIndex > [self.nSamplesTextField.text intValue])
    {
        [self.timer invalidate];
    }
}

@end
