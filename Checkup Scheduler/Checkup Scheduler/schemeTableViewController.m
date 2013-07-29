//
//  schemeTableViewController.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 6/25/13.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "schemeViewController.h"
#import "schemeTableViewController.h"

@interface schemeTableViewController ()

//@property (strong, nonatomic) UIActionSheet *actionSheet;

@end

@implementation schemeTableViewController


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
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addSchemeButton:)];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:self.editButtonItem, addButton, nil ];

    [self.view setBackgroundColor:[UIColor greenColor]];
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
    return [self.schemeNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"schemeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self.schemeNames objectAtIndex:indexPath.row];
    [cell setBackgroundColor:[self.preferences backgroundColor]];
    [cell.textLabel setTextColor:[self.preferences textColor]];
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
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        [self.schemeNames removeObjectAtIndex:indexPath.row];
        [self.schemePicker reloadAllComponents];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        [tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *a = [self.schemeNames objectAtIndex:fromIndexPath.row];
    [self.schemeNames removeObjectAtIndex:fromIndexPath.row];
    [self.schemeNames insertObject:a atIndex:toIndexPath.row];
    [self.schemePicker reloadAllComponents];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)addSchemeButton:(id)sender
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter name" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil];
    
    alert.delegate = self;
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1)
    {
        NSString *name = [[alertView textFieldAtIndex:0] text];
        // check if name is valid
        BOOL validName = YES;
        NSString *errorMessageTitle;
        NSString *errorMessage;
        if ([name isEqualToString:@""])
        {
            validName = NO;
            errorMessageTitle = @"Error: Invalid name!";
            errorMessage = @"Name must not be empty";
        }
        if ([self.schemeNames containsObject:name])
        {
            validName = NO;
            errorMessageTitle = @"Error: Duplicate name!";
            errorMessage = @"Choose another one";
        }

        if (validName)
        {
            [self.schemeNames addObject:name];
            [self.tableView reloadData];
            [self.schemePicker reloadAllComponents];
            [self addSchemeDictionaryWithName:name];
        }
        else
        {
            //NSLog(@"name is not valid or exist");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorMessageTitle message:errorMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            alert.delegate = self;
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"cellSegue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSString *name = [self.schemeNames objectAtIndex:indexPath.row];
        
        schemeViewController  *svc = (schemeViewController *)segue.destinationViewController;
        
        [svc setTitle:name];
        [svc setSchemeDictionary:[self.schemesDictionary objectForKey:name]];
        [svc setStvc:self];
        [svc setPreferences:self.preferences];
    }
}

- (void)addSchemeDictionaryWithName:(NSString *)name
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"numEvents"];
    [dict setObject:@"My Work Calendar" forKey:@"calendarName"];
    NSMutableArray *eventIsSet = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:NO], nil];
    [dict setObject:eventIsSet forKey:@"eventIsSet"];
    
    NSMutableArray *eventDictionaries = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *tasDict = [self defaultEventDictionary];    
    [eventDictionaries addObject:tasDict];
    [dict setObject:eventDictionaries forKey:@"eventDictionaries"];
    
    [self.schemesDictionary setObject:dict forKey:name];
}

- (void)deleteSchemeDictionaryWithName:(NSString *)name
{
    [self.schemesDictionary removeObjectForKey:name];
}

- (NSMutableDictionary *)defaultEventDictionary
{
    NSMutableDictionary *tasDict = [[NSMutableDictionary alloc] init];
    [tasDict setObject:@"reminder" forKey:@"title"];
    [tasDict setObject:[NSNumber numberWithInt:0] forKey: @"days"];
    [tasDict setObject:[NSNumber numberWithInt:0] forKey: @"hours"];
    [tasDict setObject:[NSNumber numberWithInt:0] forKey: @"minutes"];
    [tasDict setObject:[NSNumber numberWithInt:0] forKey: @"durationHours"];
    [tasDict setObject:[NSNumber numberWithInt:0] forKey: @"durationMinutes"];
    [tasDict setObject:[NSNumber numberWithBool:YES] forKey: @"allDayEvent"];
    [tasDict setObject:[NSNumber numberWithBool:YES] forKey: @"reminder"];
    [tasDict setObject:[NSNumber numberWithInt:0] forKey:@"reminderTimer"];
    [tasDict setObject:[NSNumber numberWithBool:NO] forKey:@"busy"];
    return tasDict;
}

@end
