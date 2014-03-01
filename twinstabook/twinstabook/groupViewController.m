//
//  groupViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-28.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "groupViewController.h"
#import "searchTableViewController.h"
#import "optionsPickerViewDelegate.h"

//#import <FacebookSDK/FacebookSDK.h>

@interface groupViewController ()
@property (strong, nonatomic) JMPickerView *picker;
@property (strong, nonatomic) optionsPickerViewDelegate *optionsPVDelegate;
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
    NSString *name = [self.database.socialMediaNames objectAtIndex:self.database.selectedMediaNameIndex];
    [self.feedButton setTitle:name forState:UIControlStateNormal];
    
    // facebook is the first entry in the mediaNames
    [self setSecondary];

    self.membersTableView.delegate = self;
    self.membersTableView.dataSource = self;
    
    self.searchField.delegate = self;
    
    [self.searchActivityIndicator setHidden:YES];
    [self.searchActivityIndicator setHidesWhenStopped:YES];
    
    self.picker = [[JMPickerView alloc] initWithDelegate:self addingToViewController:self withDistanceToTop:65.0f];
    [self.picker hide:-1.0f];
    [self.feedButton setTitle:name forState:UIControlStateNormal];
    [self.picker selectRow:self.database.selectedMediaNameIndex inComponent:0 animated:NO];
    
    self.optionsPVDelegate = [[optionsPickerViewDelegate alloc] init];
    [self.optionsPVDelegate setDatabase:self.database];
    self.optionsPVDelegate.delegate = self;
    self.optionsPicker = [[JMPickerView alloc] initWithDelegate:self.optionsPVDelegate addingToViewController:self withDistanceToTop:65.0f];
    [self.optionsPicker hide:-1.0f];
    //[self.optionsPicker setBackgroundColor:[UIColor lightGrayColor]];
    [self.searchOptionButton setTitle:[self.database.facebookSearchOptions objectAtIndex:self.database.selectedOptionIndex] forState:UIControlStateNormal];

    UIBarButtonItem *editButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTable)];
    //UIBarButtonItem *button = [[UIBarButtonItem alloc] ini]
    self.navigationItem.rightBarButtonItem = editButtonItem;

}

- (void)editTable
{

    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditTable)];
    self.navigationItem.rightBarButtonItem = doneButtonItem;
    [self.membersTableView setEditing:YES animated:YES];

}

- (void)doneEditTable
{
    UIBarButtonItem *editButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTable)];
    self.navigationItem.rightBarButtonItem = editButtonItem;
    [self.membersTableView setEditing:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.picker hide:0.1];
    [self.optionsPicker hide:0.1];
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
    return [self.groupMembers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *member = [self.groupMembers objectAtIndex:indexPath.row];
    NSString *name = [member objectForKey:@"name"];
    cell.textLabel.text = name;
    
    NSData *imageData = [member objectForKey:@"image"];
    cell.imageView.image = [UIImage imageWithData:imageData];
    
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
        [self.groupMembers removeObjectAtIndex:indexPath.row];
        
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
    [self.picker show:0.3f];
}

- (IBAction)searchButtonClicked:(id)sender
{
    [self.searchField resignFirstResponder];
    
    int selected = self.database.selectedMediaNameIndex;
    switch (selected)
    {
        case kFacebook :
            [self facebookSearch];
            break;
            
        case kTwitter :
            [self twitterSearch];
            break;
        
        case kInstagram:
            [self instagramSearch];
            break;
            
        default:
            break;
    }

}

- (void)facebookSearch
{
    
    NSString *searchString = self.searchField.text;
    bool emptyStringSearch = NO;
    if ([searchString isEqualToString:@""])
    {
        if (self.database.selectedOptionIndex != 0)
        {
            return;
        }
        emptyStringSearch = YES;
    }
    
    [self.searchActivityIndicator setHidden:NO];
    [self.searchActivityIndicator startAnimating];
    //perform the search (add search indicator) and then segue the resulting list
    
    if (self.database.selectedOptionIndex == 0)
    {
        // search friends list
        NSMutableArray *friends = [[NSMutableArray alloc] init];

        //for (NSDictionary<FBGraphUser>* friend in self.database.facebookFriends)
        for (NSDictionary *friend in self.database.facebookFriends)
        {
            NSString *name = [friend objectForKey:@"name"];
            NSInteger len = [name rangeOfString:searchString options:NSCaseInsensitiveSearch].length;
            if (len || emptyStringSearch)
            {
                NSString *uid = [friend objectForKey:@"id"];
                NSDictionary *dict = @{@"name" : name, @"id" : uid };
                [friends addObject:dict];
            }
        }

        [self.searchActivityIndicator stopAnimating];
        [self performSegueWithIdentifier:@"searchUserSegue" sender:friends];

    }
    else
    {
        // replace all 'space' with plus sign
        searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *search = nil;

        if (self.database.selectedOptionIndex == 1)
        {
            search = [NSString stringWithFormat:@"search?q=%@&type=page",searchString];
        }
        else
        {
            search = [NSString stringWithFormat:@"search?q=%@&type=user",searchString];
        }
    /*
        [FBRequestConnection startWithGraphPath:search parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *conn, id result, NSError *error)
        {
            [self.searchActivityIndicator stopAnimating];
            
            if (!error)
            {
                NSMutableArray *pData = [result objectForKey:@"data"];
                NSLog(@"search result = %@", pData);
                [self performSegueWithIdentifier:@"searchUserSegue" sender:pData];
            }
            else
            {
                NSLog(@"error: %@",error);
            }
        }
        ];
     */
    }
 
}

- (void)twitterSearch
{
    NSString *searchString = self.searchField.text;
    bool emptyStringSearch = NO;
    if ([searchString isEqualToString:@""])
    {
        emptyStringSearch = YES;
    }
    
    [self.searchActivityIndicator setHidden:NO];
    [self.searchActivityIndicator startAnimating];
    //perform the search (add search indicator) and then segue the resulting list
    
    // search friends list
    NSMutableArray *friends = [[NSMutableArray alloc] init];
        
    for (NSDictionary *friend in self.database.twitterFriends)
    {
        NSString *name = [friend objectForKey:@"name"];
        NSInteger len = [name rangeOfString:searchString options:NSCaseInsensitiveSearch].length;
        if (len || emptyStringSearch)
        {
            NSString *uid = [friend objectForKey:@"id"];
            NSDictionary *dict = @{@"name" : name, @"id" : uid };
            [friends addObject:dict];
        }
    }
        
    [self.searchActivityIndicator stopAnimating];
    [self performSegueWithIdentifier:@"searchUserSegue" sender:friends];

}

- (void)instagramSearch
{
    NSLog(@"not included yet");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //NSLog(@"didRecieveResponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"didReceiveData");
    
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
    //NSLog(@"didFinishLoading");
    
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
        
        //NSLog(@"prepare for segue, count = %ld",[sender count]);
        NSString *feed = self.feedButton.titleLabel.text;
        [vc setMediaName:feed];
        [vc setGroupMembers:self.groupMembers];
        [vc setMembersTableView:self.membersTableView];
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
    return [self.database.socialMediaNames count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.database.socialMediaNames objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.database.selectedMediaNameIndex = row;
    [self.feedButton setTitle:[self.database.socialMediaNames objectAtIndex:row] forState:UIControlStateNormal];
    
    // facebook is the first entry in the mediaNames
    [self setSecondary];
}

#pragma mark -
#pragma mark JMPickerView delegate methods

- (void)pickerViewWasHidden:(JMPickerView *)pickerView
{
    //NSLog(@"picker hidden");
}

- (void)pickerViewWasShown:(JMPickerView *)pickerView
{
    //NSLog(@"picker is shown");
}

- (void)pickerViewSelectionIndicatorWasTapped:(JMPickerView *)pickerView
{
    //NSLog(@"picker indicator tapped");
    
    [self.picker hide:0.3f];
}


- (IBAction)searchOptionButtonPressed:(id)sender
{
    [self.optionsPicker show:0.3f];
}

- (void)setSecondary
{
    if (self.database.selectedMediaNameIndex == kFacebook)
    {
        [self.optionLabel setEnabled:YES];
        [self.optionLabel setAlpha:1.0f];
        
        [self.searchOptionButton setEnabled:YES];
        [self.searchOptionButton setAlpha:1.0f];
    }
    else
    {
        [self.optionLabel setEnabled:NO];
        [self.optionLabel setAlpha:0.0f];
        
        [self.searchOptionButton setEnabled:NO];
        [self.searchOptionButton setAlpha:0.0f];
    }
}

@end
