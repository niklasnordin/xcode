//
//  twinstabookFirstViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-17.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "twinstabookFirstViewController.h"
#import "FacebookParser.h"
#import "displayObject.h"
#import "linkWebViewController.h"

@interface twinstabookFirstViewController ()

@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) NSMutableArray *feedArray;
@property (strong, nonatomic) NSMutableArray *uidsToLoad;
@property (strong, nonatomic) NSMutableDictionary *uidLoaded;
@property (strong, nonatomic) NSString *selectedLinkForWebview;
@end

@implementation twinstabookFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.appDelegate = (twinstabookAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!self.appDelegate.database)
    {
        self.appDelegate.database = [[tif_db alloc] init];
        self.database = self.appDelegate.database;
    }
    
    self.picker = [[JMPickerView alloc] initWithDelegate:self addingToViewController:self withDistanceToTop:20.0f];
    [self.picker hide:-1.0f];
    [self.feedButton setTitle:[self nameForPicker:self.database.selectedFeedIndex] forState:UIControlStateNormal];
    [self.picker selectRow:self.database.selectedFeedIndex inComponent:0 animated:NO];
 
    // setup the refresh controller for the tableview
    self.refreshController = [[UIRefreshControl alloc] init];
    [self.refreshController addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    self.feedTableView.delegate = self;
    self.feedTableView.dataSource = self;
    [self.feedTableView addSubview:self.refreshController];
    
    self.feedArray = [[NSMutableArray alloc] init];
    self.selectedLinkForWebview = [[NSString alloc] init];
    
    if (self.database.useFacebook)
    {
        [self.database openFacebookInViewController:self];
    }
    
    if (self.database.useTwitter)
    {
        [self.database openTwitterInViewController:self];
    }
    
    if (self.database.useInstagram)
    {
        // initialize instagram
    }

}

- (void)refresh:(UIRefreshControl *)sender
{
    
    if (self.database.useFacebook)
    {
        FBSession *session = [FBSession activeSession];
        
        if (!session.isOpen)
        {
            NSLog(@"FB session is NOT open");
            return;
        }
        
        //NSString *startPage = @"/me/feed";
        
        self.database.lastUpdate = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
        if (self.database.selectedFeedIndex == 0)
        {
            NSInteger num = self.database.facebookFriends.count;
            self.uidsToLoad = [[NSMutableArray alloc] initWithCapacity:num];
            self.uidLoaded = [[NSMutableDictionary alloc] init];
            for (int i=0; i<num; i++)
            {
                NSDictionary<FBGraphUser>* friend = self.database.facebookFriends[i];
                self.uidsToLoad[i] = friend.id;
                [self.uidLoaded setObject:[[NSNumber alloc] initWithBool:NO] forKey:friend.id];
            }
            
            for (NSDictionary<FBGraphUser> *friend in self.database.facebookFriends)
            {
                //NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
                NSString *uid = friend.id;
                [self readFacebookFeed:uid withRefresher:sender];
            }
        }
        else
        {
            NSString *feedGroup = [self.database.groups objectAtIndex:self.database.selectedFeedIndex-1];
            NSArray *members = [self.database.groupMembers objectForKey:feedGroup];
            for (NSDictionary *user in members)
            {
                //NSLog(@"user = %@",user);
                NSString *uid = [user objectForKey:@"uid"];
                [self readFacebookFeed:uid withRefresher:sender];
            }
        }
        //[self readFacebookFeed: withRefresher:sender]
        
    } // end useFacebook
    
    if (self.database.useInstagram)
    {
        
    } // end useInstagram
    
    if (self.database.useTwitter)
    {
        
    } // end useTwitter

    [sender endRefreshing];
}

-(bool)checkIfAllPostsAreLoaded
{
    bool loaded = YES;
    for (int i=0; i<[self.uidsToLoad count]; i++)
    {
        NSString *uid = [self. uidsToLoad objectAtIndex:i];
        NSNumber *n = [self.uidLoaded objectForKey:uid];
        loaded = loaded && [n boolValue];
    }
    return loaded;
}

- (void)readFacebookFeed:(NSString *)uid withRefresher:(UIRefreshControl *)sender
{
    
    NSString *startPage = [NSString stringWithFormat:@"/%@/feed",uid];
    
    //NSString *startPage = @"/me/feed";

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeStyle:NSDateFormatterShortStyle];
    [format setDateStyle:NSDateFormatterShortStyle];
    NSString *str = [format stringFromDate:self.database.lastUpdate];
    [params setObject:str forKey:@"since"];

    [FBRequestConnection startWithGraphPath:startPage parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *conn, id result, NSError *error)
     {
         if (!error)
         {
             NSArray *data = [result objectForKey:@"data"];
             
             if (data)
             {
                 //[self.feedArray removeAllObjects];
                 //self.database.lastUpdate = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
                 [self.uidLoaded setObject:[[NSNumber alloc] initWithBool:YES] forKey:uid];
                 for (NSDictionary *k in data)
                 {
                     displayObject *obj = [FacebookParser parse:k];
                     if (obj)
                     {
                         [self.feedArray addObject:obj];
                     }
                 }
                 
             }
             [self.feedTableView reloadData];
             if ([self checkIfAllPostsAreLoaded])
             {
                 [sender endRefreshing];
             }
         }
         else
         {
             NSLog(@"error: %@",error);
         }
     }
     ];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)writeStories:(NSArray *)data
{
    if (data)
    {
        //for (FBGraphObject *k in data)
        for (NSDictionary *k in data)
        {
            displayObject *obj = [FacebookParser parse:k];
            if (obj)
            {
                [self.feedArray addObject:obj];
            }
        }
    }
    
}

- (void)readURLAsync:(NSString *)urlString fromConnection:(FBRequestConnection *)connection next:(BOOL)goNext
{
    if (urlString)
    {
        NSLog(@"read async: %@",urlString);
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        [conn start];
    }
}

- (void)readURL:(NSString *)urlString fromConnection:(FBRequestConnection *)connection next:(BOOL)goNext
{
    if (urlString)
    {
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *responseCode = nil;

        NSData *oResponseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&responseCode error:&error];
        
        if([responseCode statusCode] != 200)
        {
            NSLog(@"Error getting %@, HTTP status code %ld", url, [responseCode statusCode]);
            return;
        }
        
        NSError *jsonError;
        //NSString *svar = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:oResponseData options:NSJSONReadingMutableContainers error:&jsonError];

        if (!jsonError)
        {
            NSMutableArray *data = [dict objectForKey:@"data"];
            if (data)
            {
                [self writeStories:data];

                FBGraphObject *paging = [dict objectForKey:@"paging"];
                if (goNext)
                {
                    NSString *next = [paging objectForKey:@"next"];
                    [self readURL:next fromConnection:connection next:YES];
                }
                else
                {
                    NSString *previous = [paging objectForKey:@"previous"];
                    [self readURL:previous fromConnection:connection next:NO];
                }
            }
        }
    }
}

- (void)readSession:(FBSession *)session fromConnection:(FBRequestConnection *)connection fromPage:(NSString *)page
{
    //NSLog(@"page = %@",page);
    //NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    NSTimeInterval interval = -86400*1;
    //NSTimeInterval interval = -50000;

    //NSDate *start = [[NSDate alloc] initWithTimeIntervalSinceNow:interval];
    //NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //[format setTimeStyle:NSDateFormatterShortStyle];
    //[format setDateStyle:NSDateFormatterShortStyle];
    //NSString *str = [format stringFromDate:start];
    //NSLog(@"str date : %@",str);
    //[params setObject:str forKey:@"since"];
    
    [FBRequestConnection startWithGraphPath:page parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *conn, id result, NSError *error)
    {
        if (!error)
        {
            NSArray *data = [result objectForKey:@"data"];
            [self writeStories:data];
            
            //FBGraphObject *paging = [result objectForKey:@"paging"];
            //NSString *previous = [paging objectForKey:@"previous"];
            //NSString *next = [paging objectForKey:@"next"];
            //[self readURLAsync:previous fromConnection:connection next:NO];
            //[self readURLAsync:next fromConnection:connection next:YES];
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
        NSMutableArray *data = [dict objectForKey:@"data"];
        if (data)
        {
            [self writeStories:data];
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

- (IBAction)feedButtonClicked:(id)sender
{
    [self.picker show:0.3f];
}

#pragma mark -
#pragma mark Standard UIPickerView data source and delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger n = 1 + [self.database.groups count];
    
    return n;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self nameForPicker:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.database.selectedFeedIndex = row;
    [self.feedButton setTitle:[self nameForPicker:row] forState:UIControlStateNormal];

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
    [self.feedArray removeAllObjects];
    [self.feedTableView reloadData];
    self.database.lastUpdate = [[NSDate alloc] initWithTimeIntervalSinceNow:-10000000];

}

- (void)pickerViewSelectionIndicatorWasTapped:(JMPickerView *)pickerView
{
    //NSLog(@"picker indicator tapped");
    [self.picker hide:0.3f];
}

- (NSString *)nameForPicker:(NSInteger)index
{
    NSString *name = @"All";
    
    if (index > 0)
    {
        name = [self.database.groups objectAtIndex:index-1];
    }
    return name;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.feedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"feedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
   
    displayObject *obj = [self.feedArray objectAtIndex:indexPath.row];
    cell.textLabel.text = obj.mainTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
    
    displayObject *obj = [self.feedArray objectAtIndex:indexPath.row];

    //check if facebook app exists
    bool facebookExist = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
    
    if (facebookExist)
    {
        // Facebook app installed
        self.selectedLinkForWebview = obj.link;
        NSArray *tokens = [obj.link componentsSeparatedByString:@"/"];
        //NSLog(@"tokens = %@",tokens);
        NSString *last = [tokens lastObject];
        NSString *pLink = [NSString stringWithFormat:@"fb://profile/%@",last];
        NSURL *fbURL = [NSURL URLWithString:pLink];
        [[UIApplication sharedApplication] openURL:fbURL];

    }
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    displayObject *obj = [self.feedArray objectAtIndex:indexPath.row];
    //NSLog(@"link = %@",obj.link);
    self.selectedLinkForWebview = obj.link;
    [self performSegueWithIdentifier:@"weblinkSegue" sender:obj.link];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"weblinkSegue"])
    {

        linkWebViewController *vc = (linkWebViewController *)segue.destinationViewController;
        //NSString *urlString = @"http://www.google.com";
        NSLog(@"link = %@",self.selectedLinkForWebview);
        [vc setUrlString:self.selectedLinkForWebview];
    }
}

@end
