//
//  scratchyViewController.m
//  scratchy
//
//  Created by Niklas Nordin on 2013-08-11.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "scratchyViewController.h"

@interface scratchyViewController ()

@end

@implementation scratchyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"initial view controller, viewDidLoad");
    
    [_picture setImage:[UIImage imageNamed:@"seven.png"]];
    [_blocking setBackgroundColor:[UIColor blackColor]];
    [_blocking setOpaque:YES];
    [_blocking setAlpha:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
