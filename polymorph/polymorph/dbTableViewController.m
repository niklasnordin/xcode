//
//  dbTableViewController.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-31.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "dbTableViewController.h"
#import "propertyTableViewController.h"

@interface dbTableViewController ()
@property (nonatomic) int alert;

@end

@implementation dbTableViewController

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
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addSpecie)];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:self.editButtonItem, addButton, nil ];

}

-(void)addSpecie
{
    // set alert to 0 for the actionsheet
    _alert = 0;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter species name" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil];
    
    alert.delegate = self;
    //[alert dismissWithClickedButtonIndex:1 animated:NO];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    //_nameTextField = nil;
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_db.json allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSArray *species = [_db orderedSpecies];

    cell.textLabel.text = [species objectAtIndex:indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2)
    {
        UIColor *bgc = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        cell.backgroundColor = bgc;
    }
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

        NSArray *species = _db.orderedSpecies;
        NSString *specie = [species objectAtIndex:indexPath.row];
        [_db.json removeObjectForKey:specie];

        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        [tableView reloadData];
        [_parent update];

    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSLog(@"hello");
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
    
    NSArray *species = _db.orderedSpecies;
    NSString *name = [species objectAtIndex:indexPath.row];
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
    //[tf setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSArray *species = _db.orderedSpecies;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    int row = indexPath.row;
    NSString *key = [species objectAtIndex:row];
    
    [segue.destinationViewController setDb:_db];
    [segue.destinationViewController setSpecie:key];
    [segue.destinationViewController setFunctionNames:_functionNames];
    [segue.destinationViewController setTitle:key];
    [segue.destinationViewController setParent:_parent];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // clicked add specie button
    if (_alert == 0)
    {
        if (buttonIndex == 1)
        {
            NSString *name = [[alertView textFieldAtIndex:0] text];
        
            // check if name already exist
            NSArray *species = _db.species;
            bool alreadyInDB = NO;
            if ([species count])
            {
                for(int i=0; i<[species count]; i++)
                {
                    if ([name isEqualToString:[species objectAtIndex:i]])
                    {
                        alreadyInDB = YES;
                    }
                }
            }
            if (!alreadyInDB)
            {
                NSArray *keyArray = [[NSArray alloc] initWithObjects:name, nil];
                NSMutableDictionary *noDict = [[NSMutableDictionary alloc] init];
                NSArray *valArray = [[NSArray alloc] initWithObjects:noDict, nil];

                NSDictionary *dict = [[NSDictionary alloc] initWithObjects:valArray forKeys:keyArray];
                [_db.json addEntriesFromDictionary:dict];
                [self.tableView reloadData];
                [_parent update];
            }
        }
    }
    
    //clicked rename button
    if (_alert == 1)
    {
        if (buttonIndex == 1) {
            
            NSString *oldName = [alertView message];
            NSMutableString *newName = [[NSMutableString alloc] initWithString:[[alertView textFieldAtIndex:0] text]];

            // need to check if newName already exists
            NSArray *species = _db.species;
            BOOL canChangeName = YES;
            for (int i=0; i<[species count]; i++)
            {
                if ([newName isEqualToString:[species objectAtIndex:i]]) {
                    canChangeName = NO;
                }
            }
            //NSLog(@"clicked OK to change name from %@ to %@",oldName,newName);
            
            if (canChangeName)
            {
                NSDictionary *dict = [_db.json objectForKey:oldName];
            
                [_db.json setObject:dict forKey:newName];
                [_db.json removeObjectForKey:oldName];
                [self.tableView reloadData];
                if ([[_parent currentSpeciesName] isEqualToString:oldName])
                {
                    [_parent setCurrentSpeciesName:newName];
                }
                [_parent update];
            }
            else
            {
                // send an alert
                // set alert to 2 for the actionsheet
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


-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}

@end
