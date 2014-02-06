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
    
    self.searchField.delegate = self;
    
    [self.searchActivityIndicator setHidden:YES];
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //[self searchButtonClicked:nil];
    return YES;
}

- (IBAction)feedButtonClicked:(id)sender
{
    NSLog(@"name = %@", [self.feedButton.titleLabel text]);
}

- (IBAction)searchButtonClicked:(id)sender
{
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
    NSString *page = [NSString stringWithFormat:@"search?q=%@&type=user",searchString];
    //NSString *page = [NSString stringWithFormat:@"search?q=%@&type=group",searchString];

    [FBRequestConnection startWithGraphPath:page parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *conn, id result, NSError *error)
     {
         [self.searchActivityIndicator setHidden:YES];
         [self.searchActivityIndicator stopAnimating];
         
         if (!error)
         {
             NSMutableArray *data = [result objectForKey:@"data"];
             //NSLog(@"search result = %@", data);
             [self performSegueWithIdentifier:@"searchUserSegue" sender:data];
         }
         else
         {
             NSLog(@"error: %@",error);
         }
     }
     ];

 
    return;
    
    NSString *accessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    NSString *http = @"https://graph.facebook.com";
    NSString *fullSearchString = [NSString stringWithFormat:@"%@/%@?access_token=%@",http,page,accessToken];
    NSLog(@"%@",fullSearchString);
    NSURL *url = [NSURL URLWithString:fullSearchString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [conn start];

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
        
        //vc.imageCache = [[NSMutableArray alloc] initWithCapacity:[sender count]];
    }
}
@end
