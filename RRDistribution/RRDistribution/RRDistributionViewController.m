//
//  RRDistributionViewController.m
//  RRDistribution
//
//  Created by Niklas Nordin on 2013-09-28.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "RRDistributionViewController.h"

@interface RRDistributionViewController ()

@end

@implementation RRDistributionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"super view did load");
    
    NSArray *tabs = self.tabBarController.viewControllers;
    NSLog(@"tabs count = %d", [tabs count]);
    for (id tab in tabs)
    {
        NSLog(@"%@",[tab class]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
