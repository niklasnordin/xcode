//
//  equationViewController.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-24.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "equationViewController.h"

@interface equationViewController ()

@end

@implementation equationViewController
@synthesize image;
@synthesize info;

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
    NSString *fullName = [NSString stringWithFormat:@"%@.png",_functionName];
    
    UIImage *im = [UIImage imageNamed:fullName];

    [image setContentMode:UIViewContentModeScaleAspectFit];
    [image setImage:im];
    
    NSString *infoName = [NSString stringWithFormat:@"%@_info.png",_functionName];
    UIImage *infoImage = [UIImage imageNamed:infoName];

    [info setContentMode:UIViewContentModeScaleAspectFit];
    [info setImage:infoImage];
}

- (void)viewDidUnload
{
    [self setImage:nil];
    [self setInfo:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
