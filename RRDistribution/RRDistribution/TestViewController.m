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
@property (nonatomic) float sumSMD;
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
    _testButton.titleLabel.text = @"Start Test";
    _testButton.titleLabel.textAlignment = NSTextAlignmentCenter;
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
    if (self.timer.isValid)
    {
        [self.timer invalidate];
        self.testButton.titleLabel.text = @"Start Test";
        self.testButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        self.iterationIndex = 1;
        self.sumSMD = 0.0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0e-6 target:self selector:@selector(runIterations) userInfo:nil repeats:YES];
        self.testButton.titleLabel.text = @"Stop Test";
        self.testButton.titleLabel.textAlignment = NSTextAlignmentCenter;


    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)runIterations
{
    float f = [self.function sample:0.0];
    self.sumSMD += f;
    float average = self.sumSMD/self.iterationIndex;
    NSString *labelText = [NSString stringWithFormat:@"%d", self.iterationIndex];
    [self.iterationLabel setText:labelText];
    [self.SMDLabel setText:[NSString stringWithFormat:@"%f",average]];
    
    self.iterationIndex = self.iterationIndex + 1;
    if (self.iterationIndex > [self.nSamplesTextField.text intValue])
    {
        [self.timer invalidate];
        self.testButton.titleLabel.text = @"Start Test";
        self.testButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
}

@end
