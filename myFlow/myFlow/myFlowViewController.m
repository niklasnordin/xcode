//
//  myFlowViewController.m
//  myFlow
//
//  Created by Niklas Nordin on 2012-11-17.
//  Copyright (c) 2012 Niklas Nordin. All rights reserved.
//

#import "myFlowViewController.h"

@interface myFlowViewController ()

@end

@implementation myFlowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _db = [[database alloc] initWithBounds:_flowView.bounds];
    _flowView.db = _db;
    
    NSLog(@"init database");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
