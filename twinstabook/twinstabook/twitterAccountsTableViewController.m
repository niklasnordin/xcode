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
    
    // Configure the cell...
    ACAccount *account = self.accounts[indexPath.row];
    //NSLog(@"class = %@", [account class]);
    cell.textLabel.text = [account username];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }

    /*
    if ([self.selectedUsers objectForKey:userID])
    {
        // objected is already selected, so we deselect it
        [self.selectedUsers removeObjectForKey:userID];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    else
    {
        UIImage *image = cell.imageView.image;
        NSData *imageData = UIImagePNGRepresentation(image);
        NSDictionary *dict = @{@"name" : name,
                               @"uid" : userID,
                               @"image" : imageData,
                               @"type" : self.mediaName};
        
        [self.selectedUsers setObject:dict forKey:userID];
        
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
     */
}

@end
