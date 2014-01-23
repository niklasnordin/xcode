//
//  twinstabookSecondViewController.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-17.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "twinstabookAppDelegate.h"
#import "tif_db.h"

@interface loginViewController : UIViewController

@property (weak, nonatomic) twinstabookAppDelegate *appDelegate;
@property (weak, nonatomic) tif_db *database;

@property (strong,nonatomic) UIColor *defaultTextColor;

@property (weak, nonatomic) IBOutlet UISwitch *facebookSwitch;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UISwitch *twitterSwitch;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UISwitch *instagramSwitch;
@property (weak, nonatomic) IBOutlet UIButton *instagramButton;

- (IBAction)clickedFacebookSwitch:(id)sender;
- (IBAction)clickedFacebookButton:(id)sender;
- (IBAction)clickedTwitterSwitch:(id)sender;
- (IBAction)clickedTwitterButton:(id)sender;
- (IBAction)clickedInstagramSwitch:(id)sender;
- (IBAction)clickedInstagramButton:(id)sender;

@end
