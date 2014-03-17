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
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    bool hide = !self.db.useTwitter;
    [self.statusLabel setHidden:hide];
    [self.tableView setHidden:hide];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedTwitterSwitch:(UISwitch *)sender
{
    self.db.useTwitter = sender.on;

    bool hide = !sender.on;
    
    [self.tableView setHidden:hide];
    [self.statusLabel setHidden:hide];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (self.db.useTwitter)
    {
        [self.db loadAllTwitterFriendsInViewController:self];
        [self.tableView reloadData];
        ACAccount *account = self.db.selectedTwitterAccount;
        NSString *uid = [account identifier];
        self.db.twitterAccountUserID = uid;
        [defaults setObject:uid forKey:TWITTERUID];
        
    }
    NSNumber *numberTwitter = [[NSNumber alloc] initWithBool:self.db.useTwitter];
    [defaults setObject:numberTwitter forKey:USETWITTER];
    [defaults synchronize];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger num = 0;
    if (self.db.useTwitter)
    {
        num = [self.db.twitterAccounts count];
    }
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"twitterAccountCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    ACAccount *account = self.db.twitterAccounts[indexPath.row];
    NSString *username = [account username];
    
    cell.textLabel.text = username;
    
    if ([account isEqual:self.db.selectedTwitterAccount])
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ACAccount *account = self.db.twitterAccounts[indexPath.row];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([account isEqual:self.db.selectedTwitterAccount])
    {
        // already selected, do nothing
    }
    else
    {
        self.db.selectedTwitterAccountIndex = [[NSNumber alloc] initWithInteger:indexPath.row];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.db.selectedTwitterAccountIndex forKey:SELECTEDTWITTERACCOUNTINDEX];
        
        self.db.selectedTwitterAccount = account;
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [self.db loadAllTwitterFriendsInViewController:self];
        
        NSString *uid = [account identifier];
        self.db.twitterAccountUserID = uid;
        [defaults setObject:uid forKey:TWITTERUID];
        [defaults synchronize];

    }
    [tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
