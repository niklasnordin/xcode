//
//  coefficientTableViewController.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-10.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "coefficientTableViewController.h"

@interface coefficientTableViewController ()

@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (nonatomic) double inputValue;
@property (nonatomic) int selectedIndex;

@end

@implementation coefficientTableViewController

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
        UIColor *bgc = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        cell.backgroundColor = bgc;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int n = 0;
    if ([_coefficients count]) {
        n = [_coefficients count];
    }
    return n;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Coefficient";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSString *name = [NSString stringWithFormat:@"A%d",indexPath.row];
    NSDictionary *myDict = [_coefficients objectAtIndex:indexPath.row];
    NSNumber *num = [myDict objectForKey:name];
    
    cell.textLabel.text = name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%g",[num doubleValue]];
    if (indexPath.row == 1) [cell.detailTextLabel setBackgroundColor:[UIColor greenColor]];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.row;
    NSString *name = [NSString stringWithFormat:@"A%d",_selectedIndex];
    NSDictionary *myDict = [_coefficients objectAtIndex:_selectedIndex];
    NSNumber *num = [myDict objectForKey:name];
    
    NSString *msg = [NSString stringWithFormat:@"A%d",indexPath.row];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter coefficient value for" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil];
    
    alert.delegate = self;
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.delegate = self;
    [tf setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tf setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    tf.text = [[NSString alloc] initWithFormat:@"%@", num];
    
    [alert show];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        _inputValue = [[[alertView textFieldAtIndex:0] text] doubleValue];
        NSString *name = [NSString stringWithFormat:@"A%d",_selectedIndex];
        NSMutableDictionary *myDict = [_coefficients objectAtIndex:_selectedIndex];
        NSNumber *num = [[NSNumber alloc] initWithDouble:_inputValue];
        [myDict setObject:num forKey:name];
        [self.tableView reloadData];
        
    }
}

@end
