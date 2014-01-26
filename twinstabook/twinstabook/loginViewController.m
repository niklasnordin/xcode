//
//  twinstabookSecondViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-17.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "loginViewController.h"

@interface loginViewController () <FBLoginViewDelegate>

@property (strong, nonatomic) FBLoginView *fbloginView;

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
    if (!self.fbloginView)
    {
        self.fbloginView = [[FBLoginView alloc] init];
        self.fbloginView.frame = self.facebookButton.frame;
        self.fbloginView.delegate = self;
        [self.view addSubview:self.fbloginView];
        [self.fbloginView sizeToFit];
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
    self.fbloginView.userInteractionEnabled = status;
    if (status)
    {
        self.fbloginView.alpha = 1.0;
    }
    else
    {
        self.fbloginView.alpha = 0.3;
    }
   
}
- (IBAction)clickedFacebookSwitch:(UISwitch *)sender
{
    self.database.useFacebook = sender.on;
    [self setButtonStatus:sender.on forButton:self.facebookButton];
    [self updateFacebookButton:sender.on];
}

- (IBAction)clickedFacebookButton:(id)sender
{
    NSLog(@"clicked facebook login");
}

- (IBAction)clickedTwitterSwitch:(UISwitch *)sender
{
    self.database.useTwitter = sender.on;
    [self setButtonStatus:sender.on forButton:self.twitterButton];
}

- (IBAction)clickedTwitterButton:(id)sender
{
    NSLog(@"clicked twitter login");
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

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    // this is called when you have logged in
    // first get the buttons set for login mode
    //self.buttonPostPhoto.enabled = YES;
    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
    //[self.buttonPostStatus setTitle:@"Post Status Update (Logged On)" forState:self.buttonPostStatus.state];
    NSLog(@"loginViewShowingLoggedInUser");
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    NSLog(@"loginViewFetchUserInfo");
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    // this is called after you have logged out
    NSLog(@"loginViewShowingLoggedOutUser");
}


- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}
@end
