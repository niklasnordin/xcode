//
//  TestViewController.m
//  RRDistribution
//
//  Created by Niklas Nordin on 2013-09-28.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "TestViewController.h"
#include "gammaFunctions.h"

@interface TestViewController ()
@property (nonatomic) int iterationIndex;
@property (nonatomic) float sumSMD;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIColor *normalStateColor;
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
    //[self.iterationLabel setText:@"kalle"];
    //_testButton.titleLabel.text = @"Start Test";
    //_testButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.testButton setTitle:@"Start Test" forState:UIControlStateNormal];
    _normalStateColor = self.testButton.titleLabel.textColor;
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
    [self.kTextField setText:[NSString stringWithFormat:@"%g",self.delegate.k]];
    [self.lambdaTextField setText:[NSString stringWithFormat:@"%g",self.delegate.lambda]];
    [self.delegate calculatePDFValues];
}

- (IBAction)clearButtonPressend:(id)sender
{
    self.iterationIndex = 0;
    self.sumSMD = 0.0;
    [self.delegate clearPDF];
    [self updateLabels:0 smd:0 dv90:0];
}

- (IBAction)TestButtonPressed:(id)sender
{

    if (self.timer.isValid)
    {
        [self.timer invalidate];
        [self.testButton setTitle:@"Continue Test" forState:UIControlStateNormal];
        [self.testButton.titleLabel setTextColor:self.normalStateColor];
        [self.testButton setTitleColor:self.normalStateColor forState:UIControlStateNormal];
    }
    else
    {
        self.function.k = self.delegate.k;
        self.function.lambda = self.delegate.lambda;

        if (self.iterationIndex >= [self.nSamplesTextField.text intValue])
        {
            //NSLog(@"helloooo");
            self.iterationIndex = 1;
            self.sumSMD = 0.0;
            [self.smdLabel setText:@""];
            
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0e-6 target:self selector:@selector(runIterations) userInfo:nil repeats:YES];

        [self.testButton setTitle:@"Stop Test" forState:UIControlStateNormal];
        [self.testButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)updateLabels:(int)it smd:(double)smd dv90:(double)dv90
{
    NSString *labelText = [NSString stringWithFormat:@"%d", self.iterationIndex];
    [self.iterationLabel setText:labelText];
    
    NSString *smdText = [NSString stringWithFormat:@"%g",smd*1.0e+6];
    [self.smdLabel setText:smdText];
    [self.dv90Label setText:[NSString stringWithFormat:@"%g",dv90*1.0e+6]];
}

- (void)runIterations
{
    float x = ((float)rand())/RAND_MAX;
    x = fminf(x, 1.0-1.0e-6);
    float f = [self.function sample:x];
    [self.delegate addDrop:f];
    float dv90 = [self.delegate findDv90];
    float smd = [self.delegate findSMD];
    
    if (self.iterationIndex % 100 == 0)
    {
        [self updateLabels:self.iterationIndex smd:smd dv90:dv90];
    }
    
    self.iterationIndex = self.iterationIndex + 1;
    
    // max iterations reached
    if (self.iterationIndex > [self.nSamplesTextField.text intValue])
    {
        [self updateLabels:self.iterationIndex smd:smd dv90:dv90];

        //NSLog(@"done");
        [self.timer invalidate];
        [self.testButton setTitle:@"Start Test" forState:UIControlStateNormal];
        [self.testButton setTitleColor:self.normalStateColor forState:UIControlStateNormal];
        self.iterationIndex = 0;
        self.sumSMD = 0.0;
        [self.delegate clearPDF];
    }
}

- (IBAction)findRangeButtonClicked:(id)sender
{
    [self.delegate calculatePDFValues];
}
@end
