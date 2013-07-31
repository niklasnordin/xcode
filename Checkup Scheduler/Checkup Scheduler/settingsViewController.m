//
//  settingsViewController.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-07-13.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "settingsViewController.h"
#import "colorSettingsViewController.h"
#import "QuartzCore/QuartzCore.h"

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


- (void)setupButton:(UIButton *)button withColor:(UIColor *)color
{
    
    [button setBackgroundColor:color];
    [button setTitleColor:self.preferences.textColor forState:UIControlStateNormal];
    [button setTitleColor:self.preferences.selectedTextColor forState:UIControlStateHighlighted];
    
    [button.layer setCornerRadius:15.0f];
    [button.layer setMasksToBounds:NO];
    [button.layer setBorderWidth:2.0f];
    [button.layer setBorderColor:[self.preferences.selectedButtonColor CGColor]];
    
    [button.layer setShadowColor:[UIColor blackColor].CGColor];
    [button.layer setShadowOpacity:0.8];
    [button.layer setShadowRadius:2.0f];
    [button.layer setShadowOffset:CGSizeMake(2.0f, 2.0f)];
}

- (void)viewWillAppear:(BOOL)animated
{
    //[super viewWillAppear:animated];
    [self.view setBackgroundColor:self.preferences.backgroundColor];
    [self setupButton:self.backgroundColorButton withColor:self.preferences.backgroundColor];
    [self setupButton:self.textColorButton withColor:self.preferences.backgroundColor];
    self.navigationController.navigationBar.tintColor = self.preferences.backgroundColor;


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

- (IBAction)pressedButton:(UIButton *)sender
{
    [self setupButton:sender withColor:self.preferences.selectedButtonColor];
}

- (IBAction)touchCancelled:(UIButton *)sender
{
    [self setupButton:sender withColor:self.preferences.backgroundColor];
}

@end
