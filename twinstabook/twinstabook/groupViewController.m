//
//  groupViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-28.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "groupViewController.h"

@interface groupViewController ()

@end

@implementation groupViewController

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
    self.appDelegate = (twinstabookAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.database = self.appDelegate.database;
    
	// Do any additional setup after loading the view.
    NSString *name = [self.database.mediaNames objectAtIndex:self.database.selectedMediaName];
    [self.feedButton setTitle:name forState:UIControlStateNormal];
    
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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

    static NSString *CellIdentifier = @"SearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
    }
    
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
        [self.searchTableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (IBAction)feedButtonClicked:(id)sender
{
    NSLog(@"name = %@", [self.feedButton.titleLabel text]);
}
@end
