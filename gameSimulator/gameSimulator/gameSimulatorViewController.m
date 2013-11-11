//
//  gameSimulatorViewController.m
//  gameSimulator
//
//  Created by Niklas Nordin on 2013-11-09.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "gameSimulatorViewController.h"

@interface gameSimulatorViewController ()

@end

@implementation gameSimulatorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    int nx = self.view.frame.size.width;
    int ny = self.view.frame.size.height;
    
    _engine = [[gameEngine alloc] initWithNx:nx Ny:ny];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
