//
//  RRDistributionViewController.m
//  RRDistribution
//
//  Created by Niklas Nordin on 2013-09-28.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "RRDistributionViewController.h"
#import "TestViewController.h"
#include "gammaFunctions.h"

@interface RRDistributionViewController ()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIColor *normalStateColor;
@property (nonatomic) float err;
@property (nonatomic) float previousErr;
@property (nonatomic) float dv90Target;
@property (nonatomic) float smdTarget;
@property (nonatomic) float urlx;
@property (nonatomic) BOOL calculationAborted;
@property (nonatomic) int iteration;
@end

@implementation RRDistributionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _function = [[RosinRammlerPDF alloc] init];
    
    NSArray *tabs = self.tabBarController.viewControllers;
    _calculationAborted = NO;
    _smdTargetTextField.delegate = self;
    _dv90TargetTextField.delegate = self;
    for (id tab in tabs)
    {
        // set the function in the test view controller
        if ([tab class] == [TestViewController class])
        {
            TestViewController *tvc = (TestViewController *)tab;
            tvc.function = _function;
            tvc.delegate = self;
            _normalStateColor = self.calculateButton.titleLabel.textColor;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)calculateInBackground
{
    [self performSelectorInBackground:@selector(calculateValues) withObject:nil];
}

- (void)calculateValues
{
    double errMax = 1.0e-3;
    double delta = 1.0e-5;
    self.iteration++;
    double smd_0 = smdCalc(self.k, self.lambda);
    //NSLog(@"smd_0 = %g",smd_0*1.0e+6);
    double d90_0 = self.lambda*find_Dv(self.k, 0.9);
    //NSLog(@"dv90 = %g",d90_0*1.0e+6);
    self.previousErr = self.err;
    self.err = sqrt( pow(smd_0/self.smdTarget-1.0, 2) + pow(d90_0/self.dv90Target-1.0, 2) );

    double k1 = self.k*(1.0 + delta);
    double lam1 = self.lambda*(1.0 + delta);
    
    //double dk = k1 - self.k;
    //double dlam = lam1 - self.lambda;
    
    double smd_k1 = smdCalc(k1, self.lambda);
    double d90_k1 = self.lambda*find_Dv(k1, 0.9);
        
    double smd_l1 = smdCalc(self.k, lam1);
    double d90_l1 = lam1*find_Dv(self.k, 0.9);
        
    double errk1 = sqrt( pow(smd_k1/self.smdTarget-1.0, 2) + pow(d90_k1/self.dv90Target-1.0, 2) );
    double errl1 = sqrt( pow(smd_l1/self.smdTarget-1.0, 2) + pow(d90_l1/self.dv90Target-1.0, 2) );
        
    double dkErr = errk1 - self.err;
    double dlErr = errl1 - self.err;
        
    self.k -= self.urlx*dkErr;
    self.lambda -= self.urlx*dlErr;
    
    [self.iterationLabel setText:[NSString stringWithFormat:@"Iteration = %d",self.iteration]];
    [self.kLabel setText:[NSString stringWithFormat:@"k = %g, urlx = %g",self.k, self.urlx]];
    [self.lambdaLabel setText:[NSString stringWithFormat:@"lambda = %g",self.lambda]];
    [self.smdLabel setText:[NSString stringWithFormat:@"SMD = %f",smd_0*1.0e+6]];
    [self.dv90Label setText:[NSString stringWithFormat:@"Dv90 = %f",d90_0*1.0e+6]];

    if (self.err >= self.previousErr)
    {
        self.urlx *= 0.9;
    }
    else
    {
        self.urlx *= 1.0001;
    }
    
    if ((self.err < errMax) || (self.urlx < 1.0e-10))
    {
        [self.timer invalidate];
        [self.calculateButton setTitle:@"Calculate" forState:UIControlStateNormal];
        [self.calculateButton setTitleColor:self.normalStateColor forState:UIControlStateNormal];
        self.calculationAborted = NO;
    }
}

- (IBAction)calculateButtonPressed:(id)sender
{

    if (self.timer.isValid)
    {
        self.calculationAborted = YES;
        [self.timer invalidate];
        [self.calculateButton setTitle:@"Continue Calculation" forState:UIControlStateNormal];
        [self.calculateButton.titleLabel setTextColor:self.normalStateColor];
        [self.calculateButton setTitleColor:self.normalStateColor forState:UIControlStateNormal];
    }
    else
    {
        self.smdTarget = 1.0e-6*[self.smdTargetTextField.text floatValue];
        self.dv90Target = 1.0e-6*[self.dv90TargetTextField.text floatValue];
        
        if (!self.calculationAborted)
        {
            self.err = 1.0;
            self.urlx = 1.0e-2;
            self.k = 0.6;
            self.lambda = self.smdTarget;
            self.previousErr = 2.0;
            self.iteration = 0;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0e-6 target:self selector:@selector(calculateValues) userInfo:nil repeats:YES];
        
        [self.calculateButton setTitle:@"Stop Calculation" forState:UIControlStateNormal];
        [self.calculateButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
