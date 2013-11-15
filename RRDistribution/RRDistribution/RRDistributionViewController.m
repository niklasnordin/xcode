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
@property (nonatomic) float dv90Target;
@property (nonatomic) float smdTarget;
@property (nonatomic) float deltak;
@property (nonatomic) float deltal;
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
    _urlxTtextField.delegate = self;
    
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
    double dk = self.deltak*self.k;
	double dl = self.deltal*self.lambda;
    
    double errMax = 1.0e-7;
    self.iteration++;
    double smd_0 = smdCalc(self.k, self.lambda);
    double d90_0 = self.lambda*find_Dv(self.k, 0.9);
    self.err = sqrt( pow(smd_0/self.smdTarget-1.0, 2) + pow(d90_0/self.dv90Target-1.0, 2) );
    
    double smd_k0 = smdCalc(self.k - dk, self.lambda);
    double d90_k0 = self.lambda*find_Dv(self.k - dk, 0.9);
    double smd_l0 = smdCalc(self.k, self.lambda - dl);
    double d90_l0 = (self.lambda - dl)*find_Dv(self.k, 0.9);

    double smd_k1 = smdCalc(self.k + dk, self.lambda);
    double d90_k1 = self.lambda*find_Dv(self.k + dk, 0.9);
    double smd_l1 = smdCalc(self.k, self.lambda + dl);
    double d90_l1 = (self.lambda + dl)*find_Dv(self.k, 0.9);
        
    double errk0 = sqrt( pow(smd_k0/self.smdTarget-1.0, 2) + pow(d90_k0/self.dv90Target-1.0, 2) );
    double errl0 = sqrt( pow(smd_l0/self.smdTarget-1.0, 2) + pow(d90_l0/self.dv90Target-1.0, 2) );
    double errk1 = sqrt( pow(smd_k1/self.smdTarget-1.0, 2) + pow(d90_k1/self.dv90Target-1.0, 2) );
    double errl1 = sqrt( pow(smd_l1/self.smdTarget-1.0, 2) + pow(d90_l1/self.dv90Target-1.0, 2) );
    
    double errOutside = fmin(errk0, fmin(errl0, fmin(errk1, errl1) ) );

    if (errOutside < self.err)
	{
	    if (errk0 < fmin(errl0, fmin(errk1, errl1)))
	    {
            self.k -= dk;
	    }
	    else
	    {
            if (errl0 < fmin(errk1, errl1))
            {
                self.lambda -= dl;
            }
            else
            {
                if (errk1 < errl1)
                {
                    self.k += dk;
                }
                else
                {
                    self.lambda += dl;
                }
            }
	    }
	}
	else
	{
	    self.deltak *= 0.5;
	    self.deltal *= 0.5;
	}

    [self.iterationLabel setText:[NSString stringWithFormat:@"Iteration = %d",self.iteration]];
    [self.kLabel setText:[NSString stringWithFormat:@"k = %g",self.k]];
    [self.lambdaLabel setText:[NSString stringWithFormat:@"lambda = %g",self.lambda]];
    [self.smdLabel setText:[NSString stringWithFormat:@"SMD = %f",smd_0*1.0e+6]];
    [self.dv90Label setText:[NSString stringWithFormat:@"Dv90 = %f",d90_0*1.0e+6]];

    if ((self.err < errMax))
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
            self.deltak = 0.1;
            self.deltal = 0.1;
            self.k = 1.0;
            self.lambda = self.smdTarget;
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
