//
//  groupTableViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-28.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "groupTableViewController.h"
#import "twinstabookFirstViewController.h"
#import "AddGroupMembersViewController.h"

@interface groupTableViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;

@end

@implementation groupTableViewController

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


    self.appDelegate = (twinstabookAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.database = self.appDelegate.database;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroup)];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:self.editButtonItem, addButton, nil ];
    
    // setup for the slider
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addGroup
{
    NSLog(@"add group");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter group name" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil];
    
    alert.delegate = self;
    //[alert dismissWithClickedButtonIndex:1 animated:NO];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.database.groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    /*
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    */
    // Configure the cell...
    cell.textLabel.text = [self.database.groups objectAtIndex:indexPath.row];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.database.groups removeObjectAtIndex:indexPath.row];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        [tableView reloadData];
        [self.tableView reloadData];
        
        // reload the group to the picker in first view
        UITabBarController *tabController = self.tabBarController;
        NSArray *vc = [tabController viewControllers];
        twinstabookFirstViewController *first = (twinstabookFirstViewController *)[vc objectAtIndex:0];
        // check if the last object has been removed
        NSInteger nFeeds = 1 + [self.database.groups count];
        if (self.database.selectedFeedIndex >= nFeeds)
        {
            self.database.selectedFeedIndex = 0;
            [first.picker selectRow:0 inComponent:0 animated:NO];
            [first.feedButton setTitle:[first nameForPicker:0] forState:UIControlStateNormal];
        }

        [first.picker reloadAllComponents];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Navigation
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{


    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSString *key = [self.database.groups objectAtIndex:indexPath.row];
    NSMutableArray *groupMembers = [self.database.groupMembers objectForKey:key];
    //NSLog(@"groupMembers = %@",groupMembers);
    AddGroupMembersViewController *vc = (AddGroupMembersViewController *)segue.destinationViewController;
    
    [vc setTitle:key];
    [vc setGroupMembers:groupMembers];
    [vc setDatabase:self.database];
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 1)
    {
        NSString *name = [[alertView textFieldAtIndex:0] text];
            
        // check if name already exist
        NSArray *names = self.database.groups;
        bool alreadyInDB = NO;
        if ([names count])
        {
            for(int i=0; i<[names count]; i++)
            {
                if ([name isEqualToString:[names objectAtIndex:i]])
                {
                    alreadyInDB = YES;
                }
            }
        }
        if (!alreadyInDB)
        {
            [self.database.groups addObject:name];
            NSMutableArray *members = [[NSMutableArray alloc] init];
            [self.database.groupMembers setObject:members forKey:name];
            [self.tableView reloadData];

        }
    }

 }


-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}

@end
