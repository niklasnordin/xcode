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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.accounts count];
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
    ACAccount *account = self.accounts[indexPath.row];
    NSString *username = [account username];
    
    cell.textLabel.text = username;
    
    if ([self.selected objectForKey:username])
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
    
    ACAccount *account = self.accounts[indexPath.row];
    NSString *username = [account username];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.selected objectForKey:username])
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [self.selected removeObjectForKey:username];
    }
    else
    {
        //NSLog(@"account = %@", account);
        NSString *id = account.identifier;
        NSString *key = [[self.selected allKeys] lastObject];
        [self.selected removeObjectForKey:key];
        [self.selected setObject:id forKey:username];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    [tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
