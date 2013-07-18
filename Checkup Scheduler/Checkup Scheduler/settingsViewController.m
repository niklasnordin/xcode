//
//  settingsViewController.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-07-13.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "settingsViewController.h"
#import "colorSettingsViewController.h"

@interface settingsViewController ()

@end

@implementation settingsViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    //[super viewWillAppear:animated];
    [self.view setBackgroundColor:self.preferences.backgroundColor];
    [self.backgroundColorButton setBackgroundColor:self.preferences.backgroundColor];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"backgroundColorSegue"])
    {
        colorSettingsViewController *csvc = segue.destinationViewController;
        [csvc setColor:self.preferences.backgroundColor];
        [csvc setBackgroundColor:self.preferences.backgroundColor];
        [csvc setTextColor:self.preferences.textColor];
        [csvc setParent:self];
        [csvc setEditingBackgroundColor:YES];
        [csvc setTitle:@"Background Color"];
    }
    else if ([segue.identifier isEqualToString:@"textColorSegue"])
    {
        colorSettingsViewController *csvc = segue.destinationViewController;
        [csvc setColor:self.preferences.textColor];
        [csvc setBackgroundColor:self.preferences.backgroundColor];
        [csvc setTextColor:self.preferences.textColor];
        [csvc setParent:self];
        [csvc setEditingBackgroundColor:NO];
        [csvc setTitle:@"Text Color"];

    }
}

@end
