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
        float k = [self.kTextField.text floatValue];
        float lambda = [self.lambdaTextField.text floatValue];
        self.function.k = k;
        self.function.lambda = lambda;
        float average = lambda*tgammaf(1.0+1.0/k);
        [self.dv90Label setText:[NSString stringWithFormat:@"%g",average]];
        if (self.iterationIndex >= [self.nSamplesTextField.text intValue])
        {
            self.iterationIndex = 1;
            self.sumSMD = 0.0;
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

- (void)runIterations
{
    float x = ((float)rand())/RAND_MAX;
    float f = [self.function sample:x];
    self.sumSMD += f;
    float lambda = [self.lambdaTextField.text floatValue];
    float k = [self.kTextField.text floatValue];
    float smd = lambda*tgammaf(1.0 + 3.0/k)/tgammaf(1.0+2.0/k);
    //float dv90 = lambda*find_Dv(k, 0.9);
    NSString *labelText = [NSString stringWithFormat:@"%d", self.iterationIndex];
    [self.iterationLabel setText:labelText];
    [self.smdLabel setText:[NSString stringWithFormat:@"%g",smd*1.0e+6]];
    //[self.dv90Label setText:[NSString stringWithFormat:@"%g",dv90*1.0e+6]];
    
    self.iterationIndex = self.iterationIndex + 1;
    if (self.iterationIndex > [self.nSamplesTextField.text intValue])
    {
        [self.timer invalidate];
        [self.testButton setTitle:@"Start Test" forState:UIControlStateNormal];
        [self.testButton setTitleColor:self.normalStateColor forState:UIControlStateNormal];
    }
}

@end
