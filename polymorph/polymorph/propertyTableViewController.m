//
//  propertyTableViewController.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-01.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "propertyTableViewController.h"
#import "setPropertyViewController.h"

@interface propertyTableViewController ()

@property (nonatomic) int alert;

@end

@implementation propertyTableViewController

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
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self
                                                  action:@selector(addProperty)];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:self.editButtonItem, addButton, nil ];

}


-(void)addProperty
{
    _alert = 0;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter property name" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil];
    
    alert.delegate = self;
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];

    [alert show];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2)
    {
        UIColor *bgc = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        cell.backgroundColor = bgc;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.db propertiesForSpecie:_specie] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"property";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSArray *properties = [self.db orderedPropertiesForSpecie:_specie];
    cell.textLabel.text = [properties objectAtIndex:indexPath.row];
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

        NSMutableDictionary *propertiesDict = [_db.json objectForKey:_specie];
        NSArray *propertyNames = [_db orderedPropertiesForSpecie:_specie];
        NSString *property = [propertyNames objectAtIndex:indexPath.row];
        [propertiesDict removeObjectForKey:property];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        [tableView reloadData];
        [_parent update];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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

#pragma mark - Table view delegate


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // set alert to 1 for the actionsheet
    _alert = 1;

    NSArray *properties = [_db orderedPropertiesForSpecie:_specie];
    NSString *name = [properties objectAtIndex:indexPath.row];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter new name for:"
                                                    message:name
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Enter", nil];
    
    alert.delegate = self;
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.delegate = self;
    [tf setClearButtonMode:UITextFieldViewModeWhileEditing];
    tf.text = name;
    
    [alert show];
}

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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_alert == 0)
    {
        if (buttonIndex == 1)
        {
            NSString *name = [[alertView textFieldAtIndex:0] text];
            bool propertyAlreadyExist = NO;
            NSArray *properties = [self.db propertiesForSpecie:_specie];
            // check if property already exist
            if ([properties count])
            {
                for (int i=0; i<[properties count]; i++) {
                    if ([name isEqualToString:[properties objectAtIndex:i]])
                    {
                        propertyAlreadyExist = YES;
                    }
                }
            }
            if (!propertyAlreadyExist)
            {
                NSMutableDictionary *specDict = [_db.json objectForKey:_specie];
            
                NSDictionary *defaultPropDict = [_db createEmptyPropertyDict];
                NSDictionary *propDict = @{ name : defaultPropDict };
                [specDict addEntriesFromDictionary:propDict];
            
                [self.tableView reloadData];
                [_parent update];
            }
        }
    }
    
    if (_alert == 1)
    {
        if (buttonIndex == 1) {
            NSString *oldName = [alertView message];
            NSMutableString *newName = [[NSMutableString alloc] initWithString:[[alertView textFieldAtIndex:0] text]];
            
            // need to check if newName already exists
            
            NSMutableDictionary *specDict = [_db.json objectForKey:_specie];
            NSArray *properties = [_db propertiesForSpecie:_specie];
            
            BOOL canChangeName = YES;

            for (int i=0; i<[properties count]; i++)
            {
                if ([newName isEqualToString:[properties objectAtIndex:i]]) {
                    canChangeName = NO;
                }
            }
            if (canChangeName)
            {
                NSDictionary *dict = [specDict objectForKey:oldName];
            
                [specDict setObject:dict forKey:newName];
                [specDict removeObjectForKey:oldName];
                [self.tableView reloadData];
                if ([[_parent currentPropertyName] isEqualToString:oldName])
                {
                    [_parent setCurrentPropertyName:newName];
                }
                [_parent update];
            }
            else
            {
               // send an alert
                _alert = 2;
                
                NSString *title = [NSString stringWithFormat:@"%@ is already taken. Please choose another one", newName];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
                
                alert.delegate = self;
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
            }
        }
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    int row = indexPath.row;
    NSArray *properties = [self.db orderedPropertiesForSpecie:_specie];
    NSString *key = [properties objectAtIndex:row];
    
    [segue.destinationViewController setDb:_db];
    [segue.destinationViewController setSpecie:_specie];
    [segue.destinationViewController setProperty:key];
    [segue.destinationViewController setFunctionNames:_functionNames];
    
    [segue.destinationViewController setTitle:key];
    [segue.destinationViewController setParent:_parent];

}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}

@end
