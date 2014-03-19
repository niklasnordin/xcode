//
//  FacebookSettingsViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-19.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "FacebookSettingsViewController.h"

@interface FacebookSettingsViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (weak, nonatomic) IBOutlet UISwitch *facebookSwitch;
- (IBAction)clickedSwitch:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation FacebookSettingsViewController

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
    
    // setup for the slider
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    [self.facebookSwitch setOn:self.db.useFacebook];
    if (self.db.useFacebook)
    {
        [self.db openFacebookInViewController:self withCompletionsHandler:^(BOOL success) {
            if (success)
            {
                self.statusLabel.hidden = NO;
                [self.statusLabel setText:[NSString stringWithFormat:@"Logged in as : %@",[self.db facebookUsername]]];
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:self.db.facebookAccountUserID forKey:FACEBOOKUID];
                [defaults synchronize];

            }
        }];
//        [self.statusLabel setText:[NSString stringWithFormat:@"Logged in as : %@",[self.db facebookUsername]]];
    }
    else
    {
        self.statusLabel.hidden = YES;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedSwitch:(UISwitch *)sender
{
    self.db.useFacebook = sender.on;
    if (sender.on)
    {
        [self.db openFacebookInViewController:self withCompletionsHandler:^(BOOL success) {
            if (success)
            {
                self.statusLabel.hidden = !sender.on;
                [self.statusLabel setText:[NSString stringWithFormat:@"Logged in as : %@",[self.db facebookUsername]]];
                
            }
        }];
        
        if (![self.db.facebookFriends count])
        {
            //[self.db loadAllFacebookFriends];
            [self.db loadAllFacebookFriendsWithCompletionsHandler:^(BOOL success) {
                if (success)
                {
                    //[self.statusLabel setText:[NSString stringWithFormat:@"Logged in as : %@",[self.db facebookUsername]]];
                }
            }];
        }
    }
    else
    {
        self.statusLabel.hidden = !sender.on;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSNumber *numberFacebook = [[NSNumber alloc] initWithBool:self.db.useFacebook];
    [defaults setObject:numberFacebook forKey:USEFACEBOOK];
    [defaults synchronize];
}

@end
