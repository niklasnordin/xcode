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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"backgroundColorSegue"])
    {
        //UIColor *color = self.preferences.backgroundColor;
        //NSLog(@"color = %@",color);
        colorSettingsViewController *csvc = segue.destinationViewController;
        [csvc setColor:self.preferences.backgroundColor];
        [csvc setTitle:@"Background Color"];
    }
    else if ([segue.identifier isEqualToString:@"textColorSegue"])
    {
        UIColor *color = self.preferences.textColor;
        colorSettingsViewController *csvc = segue.destinationViewController;
        [csvc setColor:color];
        [csvc setTitle:@"Text Color"];

    }
}

@end
