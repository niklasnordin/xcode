//
//  NNViewControllerViewController.m
//  slideViewControllerExample
//
//  Created by Niklas Nordin on 2014-02-17.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "NNViewControllerViewController.h"

@interface NNViewControllerViewController ()

@end

@implementation NNViewControllerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"NNView Did Load");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


#pragma mark - SWRevealViewControllerSegue Class

@implementation NNViewControllerSegue

- (void)perform
{
    if ( _performBlock != nil )
    {
        _performBlock( self, self.sourceViewController, self.destinationViewController );
    }
}

@end

