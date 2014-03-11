//
//  twinstabookFirstViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-17.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "twinstabookFirstViewController.h"
#import "FacebookParser.h"
#import "twitterParser.h"
#import "displayObject.h"
#import "linkWebViewController.h"
#import "Post.h"
#import "Post+Facebook.h"

@interface twinstabookFirstViewController ()

@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;

@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) NSMutableArray *feedArray;
@property (strong, nonatomic) NSMutableArray *uidsToLoad;
@property (strong, nonatomic) NSMutableDictionary *uidLoaded;
@property (strong, nonatomic) NSString *selectedLinkForWebview;
@property (strong, nonatomic) NSArray *twitterArray;

@end

@implementation twinstabookFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    twinstabookAppDelegate *AppDelegate = (twinstabookAppDelegate *)[[UIApplication sharedApplication] delegate];

    self.database = AppDelegate.database;
    
    self.picker = [[JMPickerView alloc] initWithDelegate:self addingToViewController:self withDistanceToTop:kDistanceFromTop];
    [self.picker hide:-1.0f];
    [self.feedButton setTitle:[self nameForPicker:self.database.selectedFeedIndex] forState:UIControlStateNormal];
    [self.picker selectRow:self.database.selectedFeedIndex inComponent:0 animated:NO];
 
    // setup the refresh controller for the tableview
    self.refreshController = [[UIRefreshControl alloc] init];
    self.refreshController.tintColor = [UIColor lightGrayColor];
    [self.refreshController addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.refreshController setTintColor:[UIColor redColor]];
    [self.refreshController setBackgroundColor:[UIColor lightGrayColor]];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeStyle:NSDateFormatterShortStyle];
    [format setDateStyle:NSDateFormatterShortStyle];
    NSString *str = [format stringFromDate:self.database.lastUpdate];
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:str];
    self.refreshController.attributedTitle = title;
    
    self.feedTableView.delegate = self;
    self.feedTableView.dataSource = self;
    [self.feedTableView addSubview:self.refreshController];
    
    self.feedArray = [[NSMutableArray alloc] init];
    self.selectedLinkForWebview = [[NSString alloc] init];
    
    if (self.database.useFacebook)
    {
        [self.database openFacebookInViewController:self withCompletionsHandler:^(BOOL success) {
            // do nothing
        }];
        [self.database loadAllFacebookFriendsWithCompletionsHandler:^(BOOL success) {
            // do nothing
        }];

    }

    if (self.database.useTwitter)
    {
        [self.database openTwitterInViewController:self];
        [self.database loadAllTwitterFriendsInViewController:self];
    }
    
    if (self.database.useInstagram)
    {
        // initialize instagram
        //[self.database openInstagramInViewController:self];
        [self.database loadAllInstagramFriendsInViewController:self withCursor:nil];
    }
    
    // setup for the slider
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    //[self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [self.feedTableView addGestureRecognizer: self.revealViewController.panGestureRecognizer];

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:moPost];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    //request.predicate = [NSPredicate predicateWithFormat:@"date"];
    //self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.database.managedDocument.managedObjectContext sectionNameKeyPath:moPost cacheName:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    //NSLog(@"%@ viewWillDisappear",[self class]);
}

- (void)refresh:(UIRefreshControl *)sender
{
    
    NSDate *now = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
    NSTimeInterval interval = [now timeIntervalSinceDate:self.database.lastUpdate];

    // dont update too often, every 60s seems good enough
    if (interval < 60)
    {
        [sender endRefreshing];
        return;
    }
    self.database.lastUpdate = now;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeStyle:NSDateFormatterShortStyle];
    [format setDateStyle:NSDateFormatterShortStyle];
    NSString *str = [format stringFromDate:self.database.lastUpdate];
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:str];
    self.refreshController.attributedTitle = title;
    
    
    if (self.database.useFacebook)
    {
        /*
        FBSession *session = [FBSession activeSession];
        
        if (!session.isOpen)
        {
            NSLog(@"FB session is NOT open");
            return;
        }
        
        //NSString *startPage = @"/me/feed";
        
        self.database.lastUpdate = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
        if (self.database.selectedFeedIndex == kFacebook)
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
        */
    } // end useFacebook
    
    if (self.database.useInstagram)
    {
        
    } // end useInstagram
    
    if (self.database.useTwitter)
    {
        [self readTwitterFeedWithRefreshed:sender];
    } // end useTwitter

    [sender endRefreshing];
}
/*
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
*/
- (void)readFacebookFeed:(NSString *)uid withRefresher:(UIRefreshControl *)sender
{
    
    //NSString *startPage = [NSString stringWithFormat:@"/%@/feed",uid];
    //NSString *startPage = @"/me/feed";

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeStyle:NSDateFormatterShortStyle];
    [format setDateStyle:NSDateFormatterShortStyle];
    NSString *str = [format stringFromDate:self.database.lastUpdate];
    [params setObject:str forKey:@"since"];
/*
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
                     DisplayObject *obj = [FacebookParser parse:k];
                     if (obj)
                     {
                         [self.feedArray addObject:obj];
                     }
                 }
                 
             }
             dispatch_async(dispatch_get_main_queue(), ^(void){
                 [self.feedTableView reloadData];
             });
             
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
  */
}

- (void)readTwitterFeedWithRefreshed:(UIRefreshControl *)sender
{
    [self.database.account requestAccessToAccountsWithType:self.database.twitterAccountType options:nil completion:^(BOOL granted, NSError *error)
    {
        if (granted)
        {
            
            ACAccount *twitterAccount = self.database.selectedTwitterAccount;

            /*
            
            [self.database.account renewCredentialsForAccount:twitterAccount completion:^(ACAccountCredentialRenewResult renewResult, NSError *error)
            {
                NSLog(@"renewed credentials");
            }];
            */
            if (twitterAccount)
            {
                NSLog(@"here i am");
                NSString *apiString = [NSString stringWithFormat:@"%@/%@/statuses/user_timeline.json", kTwitterAPIRoot, kTwitterAPIVersion];
                NSURL *request = [NSURL URLWithString:apiString];
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                [parameters setObject:@"100" forKey:@"count"];
                [parameters setObject:@"1" forKey:@"include_entities"];
                
                SLRequest *posts = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:request parameters:parameters];
                
                posts.account = twitterAccount;
                [posts performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error)
                 {
                     //NSLog(@"response = %@",response);
                     //NSLog(@"error = %@",error.debugDescription);
                     if (!error)
                     {
                         self.twitterArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                         NSLog(@"arrayPost.count = %ld",self.twitterArray.count);
                         //NSLog(@"urlResponse = %@",urlResponse);
                         dispatch_async(dispatch_get_main_queue(), ^(void){

                             if (self.twitterArray.count)
                             {
                                 // NSLog(@"class = %@",[[self.twitterArray lastObject] class]);
                                 for (NSDictionary *post in self.twitterArray)
                                 {
                                     DisplayObject *obj = [twitterParser parse:post];
                                     if (obj)
                                     {
                                         [self.feedArray addObject:obj];
                                     }
                                 }
                             }
                             [self.feedTableView reloadData];
                         });
                     }
                     else
                     {
                         NSLog(@"error = %@",[error localizedDescription]);
                     }
                     [sender endRefreshing];
                 }];
            }
            
        }
    }];
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
            DisplayObject *obj = [FacebookParser parse:k];
            if (obj)
            {
                [self.feedArray addObject:obj];
            }
        }
    }
    
}

- (IBAction)feedButtonClicked:(id)sender
{
    [self.picker show:0.3f];
    [self.navigationController setNavigationBarHidden:YES];
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
    [self.navigationController setNavigationBarHidden:NO];
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
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"feedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
   
    //Post *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //cell.textLabel.text = post.message;
    
    DisplayObject *obj = [self.feedArray objectAtIndex:indexPath.row];
    cell.textLabel.text = obj.message;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
    
    DisplayObject *obj = [self.feedArray objectAtIndex:indexPath.row];

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
    DisplayObject *obj = [self.feedArray objectAtIndex:indexPath.row];
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
