//
//  twitterAccountsTableViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-14.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "twitterAccountsTableViewController.h"

@interface twitterAccountsTableViewController ()

@end

@implementation twitterAccountsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        NSLog(@"account = %@", account);
        NSString *id = account.identifier;
        NSString *key = [[self.selected allKeys] lastObject];
        [self.selected removeObjectForKey:key];
        [self.selected setObject:id forKey:username];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
