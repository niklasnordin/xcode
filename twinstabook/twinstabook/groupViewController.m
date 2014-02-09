//
//  groupViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-28.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "groupViewController.h"
#import "searchTableViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface groupViewController ()
@property (strong, nonatomic) JMPickerView *picker;
@property (weak, nonatomic) NSMutableDictionary *groupMembers;

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
    self.groupMembers = self.database.groupMembers;
    
	// Do any additional setup after loading the view.
    NSString *name = [self.database.mediaNames objectAtIndex:self.database.selectedMediaName];
    [self.feedButton setTitle:name forState:UIControlStateNormal];
    
    self.membersTableView.delegate = self;
    self.membersTableView.dataSource = self;
    
    self.searchField.delegate = self;
    
    [self.searchActivityIndicator setHidden:YES];
    
    self.picker = [[JMPickerView alloc] initWithDelegate:self addingToViewController:self withDistanceToTop:50.0f];
    [self.picker hide];
    [self.feedButton setTitle:[self.database.mediaNames objectAtIndex:self.database.selectedMediaName] forState:UIControlStateNormal];
    [self.picker selectRow:self.database.selectedMediaName inComponent:0 animated:NO];
    
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
    NSInteger count = 0;
    for (NSString *name in self.database.mediaNames)
    {
        count += [[self.groupMembers objectForKey:name] count];
    }
    return count;
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
    NSInteger row = indexPath.row;
    NSInteger nFB = [[self.database.groupMembers objectForKey:[self.database.mediaNames objectAtIndex:0]] count];
    NSInteger nTW = [[self.database.groupMembers objectForKey:[self.database.mediaNames objectAtIndex:1]] count];
    //NSInteger nIG = [[self.database.groupMembers objectForKey:[self.database.mediaNames objectAtIndex:2]] count];
    
    NSString *name = nil;
    if (row < nFB)
    {
        NSMutableArray *members = [self.database.groupMembers objectForKey:[self.database.mediaNames objectAtIndex:0]];
        NSDictionary *data = [members objectAtIndex:row];
        NSString *uid = [[data allKeys] lastObject];
        NSDictionary *dict = [data objectForKey:uid];
        name = [dict objectForKey:@"name"];
        NSData *imageData = [dict objectForKey:@"image"];
        cell.imageView.image = [UIImage imageWithData:imageData];
    }
    else
    {
        row -= nFB;
        if (row < nFB+nTW)
        {
            name = [[self.database.groupMembers objectForKey:[self.database.mediaNames objectAtIndex:1]] objectAtIndex:row];
        }
        else
        {
            row -= nTW;
            name = [[self.database.groupMembers objectForKey:[self.database.mediaNames objectAtIndex:2]] objectAtIndex:row];
        }
    }
    cell.textLabel.text = name;
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
        //[self.database.groups removeObjectAtIndex:indexPath.row];
        NSInteger row = indexPath.row;
        NSInteger nFB = [[self.database.groupMembers objectForKey:[self.database.mediaNames objectAtIndex:0]] count];
        NSInteger nTW = [[self.database.groupMembers objectForKey:[self.database.mediaNames objectAtIndex:1]] count];
        //NSInteger nIG = [[self.database.groupMembers objectForKey:[self.database.mediaNames objectAtIndex:2]] count];
        
        if (row < nFB)
        {
            NSMutableArray *arry = [self.database.groupMembers objectForKey:[self.database.mediaNames objectAtIndex:0]];
            [arry removeObjectAtIndex:row];
        }
        else
        {
            row -= nFB;
            if (row < nFB+nTW)
            {
                NSMutableArray *arry = [self.database.groupMembers objectForKey:[self.database.mediaNames objectAtIndex:1]];
                [arry removeObjectAtIndex:row];
            }
            else
            {
                row -= nTW;
                NSMutableArray *arry = [self.database.groupMembers objectForKey:[self.database.mediaNames objectAtIndex:1]];
                [arry removeObjectAtIndex:row];
            }
        }
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        [tableView reloadData];
        [self.membersTableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //[self searchButtonClicked:nil];
    return YES;
}

- (IBAction)feedButtonClicked:(id)sender
{
    NSLog(@"name = %@", [self.feedButton.titleLabel text]);
    [self.picker show];
}

- (IBAction)searchButtonClicked:(id)sender
{
    NSMutableArray *searchResults = [[NSMutableArray alloc] init];
    NSString *searchString = self.searchField.text;
    if ([searchString isEqualToString:@""])
    {
        return;
    }
    
    [self.searchActivityIndicator setHidden:NO];
    [self.searchActivityIndicator startAnimating];
    //perform the search (add search indicator) and then segue the resulting list
    searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *userSearch = [NSString stringWithFormat:@"search?q=%@&type=user",searchString];
    NSString *pageSearch = [NSString stringWithFormat:@"search?q=%@&type=page",searchString];

    [FBRequestConnection startWithGraphPath:pageSearch parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *conn, id result, NSError *error)
     {
         
         if (!error)
         {
             NSMutableArray *pData = [result objectForKey:@"data"];
             //NSLog(@"search result = %@", pData);
             [searchResults addObjectsFromArray:pData];
             
             
             [FBRequestConnection startWithGraphPath:userSearch parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *conn, id result, NSError *error)
              {
                  [self.searchActivityIndicator setHidden:YES];
                  [self.searchActivityIndicator stopAnimating];
                  
                  if (!error)
                  {
                      NSMutableArray *uData = [result objectForKey:@"data"];
                      [searchResults addObjectsFromArray:uData];
                      //NSLog(@"search result = %@", data);
                      [self performSegueWithIdentifier:@"searchUserSegue" sender:searchResults];
                  }
                  else
                  {
                      NSLog(@"error: %@",error);
                  }
              }
              ];

         }
         else
         {
             NSLog(@"error: %@",error);
         }
     }
     ];

}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didRecieveResponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
    
    NSError *jsonError;
    //NSString *svar = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
    
    
    if (!jsonError)
    {
        NSLog(@"dict = %@",dict);
        NSMutableArray *data = [dict objectForKey:@"data"];
        if (data)
        {
            NSLog(@"%@",data);
        }
    }
    
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSLog(@"didFinishLoading");
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"didFailWithError = %@",error);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSMutableArray *)sender
{
    if ([[segue identifier] isEqualToString:@"searchUserSegue"])
    {
        searchTableViewController *vc = (searchTableViewController *)segue.destinationViewController;
        [vc setNames:sender];
        [vc setDatabase:self.database];
        
        NSLog(@"prepare for segue, count = %ld",[self.database.groupMembers count]);
        NSString *feed = self.feedButton.titleLabel.text;
        [vc setMediaName:feed];
        [vc setGroupMembers:[self.database.groupMembers objectForKey:feed]];
        [vc setMembers:self.membersTableView];
    }
}

#pragma mark -
#pragma mark Standard UIPickerView data source and delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.database.mediaNames count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.database.mediaNames objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.database.selectedMediaName = row;
    [self.feedButton setTitle:[self.database.mediaNames objectAtIndex:row] forState:UIControlStateNormal];
    if (row == 0)
    {
        // show secondary search options
    }
    else
    {
        // hide secondary seach options
    }
}

#pragma mark -
#pragma mark JMPickerView delegate methods

- (void)pickerViewWasHidden:(JMPickerView *)pickerView
{
    NSLog(@"picker hidden");
}

- (void)pickerViewWasShown:(JMPickerView *)pickerView
{
    NSLog(@"picker is shown");
}

- (void)pickerViewSelectionIndicatorWasTapped:(JMPickerView *)pickerView
{
    NSLog(@"picker indicator tapped");
    
    [self.picker hide];
}


@end
