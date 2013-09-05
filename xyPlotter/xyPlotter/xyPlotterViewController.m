//
//  xyPlotterViewController.m
//  xyPlotter
//
//  Created by Niklas Nordin on 2013-03-01.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "xyPlotterViewController.h"

@interface xyPlotterViewController ()

@end

@implementation xyPlotterViewController

-(void)setup
{
    //NSLog(@"controller setup");
    _function = [[dummyFunction alloc] init];
    _plotView.delegate = _function;
    _plotView.dataSource = _function;
    _plotView.xMin = _function.xMin;
    _plotView.xMax = _function.xMax;
    //_plotView.yMin = _function.yMin;
    //_plotView.yMax = _function.yMax;
    [_plotView setup];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
