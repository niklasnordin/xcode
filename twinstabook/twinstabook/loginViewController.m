//
//  twinstabookSecondViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-17.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "loginViewController.h"
#import "twitterAccountsTableViewController.h"

@interface loginViewController ()

@end


@implementation loginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.defaultTextColor = self.facebookButton.titleLabel.textColor;
    self.appDelegate = (twinstabookAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.database = self.appDelegate.database;
    
    [self.facebookSwitch setOn:self.database.useFacebook];
    [self setButtonStatus:self.database.useFacebook forButton:self.facebookButton];
    [self updateFacebookButton:self.database.useFacebook];

    [self.twitterSwitch setOn:self.database.useTwitter];
    [self setButtonStatus:self.database.useTwitter forButton:self.twitterButton];
    
    [self.instagramSwitch setOn:self.database.useInstagram];
    [self setButtonStatus:self.database.useInstagram forButton:self.instagramButton];

    // Create Login View so that the app will be granted "status_update" permission.
    self.database.fbloginView.frame = self.facebookButton.frame;
    [self.view addSubview:self.database.fbloginView];
    [self.database.fbloginView sizeToFit];

    NSInteger numAccounts = [self.database.twitterAccounts count];
    if (numAccounts)
    {
        NSArray *keys = [self.database.selectedTwitterAccounts allKeys];
        NSString *username = [keys lastObject];
        [self.twitterButton setTitle:username forState:UIControlStateNormal];
    }
    else
    {
        [self.twitterButton setTitle:self.database.socialMediaNames[kTwitter] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setButtonStatus:(BOOL)status forButton:(UIButton *)button
{
    UIColor *col = [UIColor redColor];
    if (status)
    {
        col = self.defaultTextColor;
    }
    [button setTitleColor:col forState:UIControlStateNormal];
    [button setEnabled:status];
}

- (void)updateFacebookButton:(BOOL)status
{
    self.database.fbloginView.userInteractionEnabled = status;
    if (status)
    {
        self.database.fbloginView.alpha = 1.0;
    }
    else
    {
        self.database.fbloginView.alpha = 0.3;
    }
   
}
- (IBAction)clickedFacebookSwitch:(UISwitch *)sender
{
    self.database.useFacebook = sender.on;
    [self setButtonStatus:sender.on forButton:self.facebookButton];
    [self updateFacebookButton:sender.on];
    if (sender.on)
    {
        [self.database loadAllFacebookFriends];
    }
}

- (IBAction)clickedFacebookButton:(id)sender
{
    NSLog(@"clicked facebook login");

}

- (IBAction)clickedTwitterSwitch:(UISwitch *)sender
{
    if (sender.on)
    {
        // set the title to the username
        NSInteger numAccounts = [self.database.twitterAccounts count];
        if (numAccounts)
        {
            NSArray *keys = [self.database.selectedTwitterAccounts allKeys];
            NSString *username = [keys lastObject];
            [self.twitterButton setTitle:username forState:UIControlStateNormal];
        }
        else
        {
            [self.twitterButton setTitle:self.database.socialMediaNames[kTwitter] forState:UIControlStateNormal];
            [sender setOn:NO animated:YES];
        }
        [self.database openTwitterInViewController:self];
    }
    else
    {
        // set the title to twitter
        [self.twitterButton setTitle:self.database.socialMediaNames[kTwitter] forState:UIControlStateNormal];
    }
    
    [self setButtonStatus:sender.on forButton:self.twitterButton];
    self.database.useTwitter = sender.on;

    if (sender.on)
    {
        [self.database loadTwitterFriends];
    }
}

- (IBAction)clickedTwitterButton:(id)sender
{
    //NSLog(@"clicked twitter login");
}

- (IBAction)clickedInstagramSwitch:(UISwitch *)sender
{
    self.database.useInstagram = sender.on;
    [self setButtonStatus:sender.on forButton:self.instagramButton];
}

- (IBAction)clickedInstagramButton:(id)sender
{
    NSLog(@"clicked instagram login");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"twitterAccountsSegue"])
    {
        // transfer database
        twitterAccountsTableViewController *vc = (twitterAccountsTableViewController *)segue.destinationViewController;
        [vc setAccounts:self.database.twitterAccounts];
        [vc setSelected:self.database.selectedTwitterAccounts];
        [vc setTwitterButton:self.twitterButton];
    }
}

@end
