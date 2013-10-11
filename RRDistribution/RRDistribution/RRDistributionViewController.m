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
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)calculateButtonPressed:(id)sender
{
    //double aa = Entire_Incomplete_Gamma_Function(double x, double nu);
    double nu = 0.9;
    double x = 0.9;
    //double aa = tgamma(nu)*(1.0-Entire_Incomplete_Gamma_Function(0.9, nu));
    double aa = gamma_i(nu, x);

    NSLog(@"aa = %f",aa);
    
}
@end
