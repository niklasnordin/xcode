//
//  twitterSettingsViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-19.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "twitterSettingsViewController.h"

@interface twitterSettingsViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (weak, nonatomic) IBOutlet UISwitch *twitterSwitch;
- (IBAction)clickedTwitterSwitch:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation twitterSettingsViewController

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

    [self.twitterSwitch setOn:self.db.useTwitter];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedTwitterSwitch:(UISwitch *)sender
{
    self.db.useTwitter = sender.on;
}
@end
