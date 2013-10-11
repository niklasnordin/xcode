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

@end

@implementation RRDistributionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _function = [[RosinRammlerPDF alloc] init];
    
    NSArray *tabs = self.tabBarController.viewControllers;

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

- (void)calculateValues
{
    float smdTarget = [self.smdTargetTextField.text floatValue];
    float dv90Target = [self.dv90TargetTextField.text floatValue];
    
    self.k = 1.0;
    self.lambda = smdTarget;
    double errMax = 1.0e-3;
    
    if (self.err < errMax)
    {
        [self.timer invalidate];
        [self.calculateButton setTitle:@"Calculate" forState:UIControlStateNormal];
        [self.calculateButton setTitleColor:self.normalStateColor forState:UIControlStateNormal];
    }
}

- (IBAction)calculateButtonPressed:(id)sender
{
    //double aa = Entire_Incomplete_Gamma_Function(double x, double nu);
    double nu = 0.9;
    double x = 0.9;
    //double aa = tgamma(nu)*(1.0-Entire_Incomplete_Gamma_Function(0.9, nu));
    double aa = gamma_i(nu, x);

    NSLog(@"aa = %f",aa);
    
    if (self.timer.isValid)
    {
        [self.timer invalidate];
        [self.calculateButton setTitle:@"Continue Calculation" forState:UIControlStateNormal];
        [self.calculateButton.titleLabel setTextColor:self.normalStateColor];
        [self.calculateButton setTitleColor:self.normalStateColor forState:UIControlStateNormal];
    }
    else
    {
        self.err = 1.0;
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
