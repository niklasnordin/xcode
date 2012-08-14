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

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter species name" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil];
    
    //[alert addSubview:_nameTextField];
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
    
    NSArray *species = [_db.json allKeys];

    cell.textLabel.text = [species objectAtIndex:indexPath.row];
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
        NSLog(@"here i am: delete");
        NSString *specie = [[_db.json allKeys] objectAtIndex:indexPath.row];
        [_db.json removeObjectForKey:specie];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_parent update];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSLog(@"here i am_insert");
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     
     */
    //NSLog(@"did select %@",indexPath);
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    NSArray *species = [_db.json allKeys];
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
    if (buttonIndex == 1)
    {
        //NSString *name = self.nameTextField.text;
        NSString *name = [[alertView textFieldAtIndex:0] text];
        
        // check if name already exist
        NSArray *species = [_db.json allKeys];
        bool alreadyInDB = NO;
        if ([species count])
        {
            for(int i=0; i<[species count];i++)
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

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}

@end
