//
//  thermoViewViewController.m
//  screetch
//
//  Created by Niklas Nordin on 2012-10-23.
//  Copyright (c) 2012 Niklas Nordin. All rights reserved.
//

#import "screetchViewController.h"

@interface screetchViewController ()

@end

@implementation screetchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _pictureView.delegate = self;
    [_pictureView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:_pictureView action:@selector(pan:)]];
    //[_pictureView set
 
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDisplayWithText:(NSString *)text
{
    _display.text = text;
}

@end
