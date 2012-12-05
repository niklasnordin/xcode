//
//  menuViewController.m
//  scratchPicture
//
//  Created by Niklas Nordin on 2012-12-05.
//  Copyright (c) 2012 Niklas Nordin. All rights reserved.
//

#import "menuViewController.h"

@interface menuViewController ()

@end

@implementation menuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"viewDidLoad");
    [_allButtons setBackgroundColor:[Settings buttonColor]];
    NSArray *subViews = _allButtons.subviews;
    UIView *sub = [subViews objectAtIndex:0];
    UIView *sub1 = [subViews objectAtIndex:1];
    UIView *sub2 = [subViews objectAtIndex:2];

    [sub setBackgroundColor:[Settings buttonColor]];
    [sub1 setBackgroundColor:[UIColor redColor]];
    [sub2 setBackgroundColor:[UIColor blueColor]];
    
    NSLog(@"subviews count =%d",[subViews count]);
    
    [_topNavigationBarItem.titleView setBackgroundColor:[UIColor redColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
