//
//  coefficientTableViewController.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-10.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "coefficientTableViewController.h"

@interface coefficientTableViewController ()

//@property (strong, nonatomic) UIActionSheet *actionSheet;
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

- (void)copyButtonPressed:(id)sender
{
    [_parent setCpArray:_coefficients];
    UIBarButtonItem *pasteButton = [self.navigationItem.rightBarButtonItems objectAtIndex:1];
    [pasteButton setEnabled:YES];
}

- (void)pasteButtonPressed:(id)sender
{

    int n = (int)[_coefficients count];
    NSArray *cp = [_parent cpArray];
    int m = (int)[cp count];

    for (int i=0; i<n; i++)
    {
        NSString *name = [_coefficientNames objectAtIndex:i];
        NSMutableDictionary *myDict = [_coefficients objectAtIndex:i];
        
        if (i < m)
        {
            NSDictionary *cpDict = [cp objectAtIndex:i];
            NSNumber *num = [cpDict objectForKey:name];
                //[myDict setDictionary:cpDict];
            [myDict setObject:num forKey:name];
        }
        
    }

    [self.tableView reloadData];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    UIBarButtonItem *copyButton = [[UIBarButtonItem alloc] initWithTitle:@"Copy" style:UIBarButtonItemStylePlain target:self action:@selector(copyButtonPressed:)];
    
    UIBarButtonItem *pasteButton = [[UIBarButtonItem alloc] initWithTitle:@"Paste" style:UIBarButtonItemStylePlain target:self action:@selector(pasteButtonPressed:)];
    
    if ([[_parent cpArray] count] == 0)
    {
        [pasteButton setEnabled:NO];
    }
    
    NSArray *buttons = [[NSArray alloc] initWithObjects:copyButton, pasteButton, nil];
    self.navigationItem.rightBarButtonItems = buttons;
    
//    [self setToolbarItems:buttons];
     
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
        UIColor *bgc = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        cell.backgroundColor = bgc;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger n = 0;
    if ([self.coefficientNames count])
    {
        n = [self.coefficientNames count];
    }
    return n;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Coefficient";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    //NSString *name = [NSString stringWithFormat:@"A%d",indexPath.row];
    NSString *name = [_coefficientNames objectAtIndex:indexPath.row];
    
    double value = 0.0;
    int nSize = (int)[_coefficients count];
    if (indexPath.row < nSize)
    {
        NSDictionary *myDict = [_coefficients objectAtIndex:indexPath.row];
        NSNumber *num = [myDict objectForKey:name];
        value = [num doubleValue];
    }
    
    cell.textLabel.text = name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.15g",value];
    //if (indexPath.row == 1) [cell.detailTextLabel setBackgroundColor:[UIColor greenColor]];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = (int)indexPath.row;
    //NSString *name = [NSString stringWithFormat:@"A%d",_selectedIndex];
    NSString *name = [_coefficientNames objectAtIndex:_selectedIndex];

    NSDictionary *myDict = [_coefficients objectAtIndex:_selectedIndex];
    NSNumber *num = [myDict objectForKey:name];
    
    //NSString *msg = [NSString stringWithFormat:@"A%d",indexPath.row];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter coefficient value for" message:name delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil];
    
    //NSArray *subviews = [alert subviews];
    //NSLog(@"[subviews count] = %d",[subviews count]);
    //UIColor *darkRed = [UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:1.0];
    //[[[alert subviews] objectAtIndex:0] setBackgroundColor:[UIColor darkGrayColor]];
    //[[[alert subviews] objectAtIndex:1] setBackgroundColor:[UIColor darkGrayColor]];
    //[[[alert subviews] objectAtIndex:2] setBackgroundColor:darkRed];
    //[[[alert subviews] objectAtIndex:3] setBackgroundColor:[UIColor darkGrayColor]];
    //[alert setBackgroundColor:[UIColor darkGrayColor]];
    //[[alert viewForBaselineLayout] setBackgroundColor:[UIColor darkGrayColor]];

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
        //NSString *name = [NSString stringWithFormat:@"A%d",_selectedIndex];
        NSString *name = [_coefficientNames objectAtIndex:_selectedIndex];

        NSMutableDictionary *myDict = [_coefficients objectAtIndex:_selectedIndex];
        NSNumber *num = [[NSNumber alloc] initWithDouble:_inputValue];
        [myDict setObject:num forKey:name];
        [self.tableView reloadData];
    }
}

@end
