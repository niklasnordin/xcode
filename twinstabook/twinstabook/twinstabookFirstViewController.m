//
//  twinstabookFirstViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-17.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "twinstabookFirstViewController.h"
#import "tifTableViewCell.h"
//#import "FacebookParser.h"
#import "UserObject.h"
#import "linkWebViewController.h"
#import "Post.h"
#import "User.h"
#import "Post+Facebook.h"
#import "Post+Twitter.h"
#import "Post+Instagram.h"

@interface twinstabookFirstViewController ()
@property (nonatomic) BOOL facebookReadDone;
@property (nonatomic) BOOL twitterReadDone;
@property (nonatomic) BOOL instagramReadDone;

@property (nonatomic) BOOL beganUpdates;
@property (strong,nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;

@property (strong, nonatomic) UIActionSheet *actionSheet;

//@property (strong, nonatomic) NSMutableArray *feedArray;
@property (strong, nonatomic) NSMutableArray *uidsToLoad;
@property (strong, nonatomic) NSMutableDictionary *uidLoaded;
@property (strong, nonatomic) NSString *selectedLinkForWebview;
@property (strong, nonatomic) NSArray *twitterArray;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (nonatomic) int nRefreshers;

@property (weak, nonatomic) IBOutlet UIImageView *facebookImageView;
@property (weak, nonatomic) IBOutlet UIImageView *twitterImageView;
@property (weak, nonatomic) IBOutlet UIImageView *instagramImageView;

@property (strong, nonatomic) NSTimer *updateTimer;

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
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString *str = [self.dateFormatter stringFromDate:self.database.lastUpdate];
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:str];
    self.refreshController.attributedTitle = title;
    
    self.feedTableView.delegate = self;
    self.feedTableView.dataSource = self;
    
    [self.feedTableView addSubview:self.refreshController];
    
    self.selectedLinkForWebview = [[NSString alloc] init];
    
    NSString *predicateTemplate = @"( postedBy.type == %d ) AND ( postedBy.belongsToAccountID == '%@' )";
    NSString *predicateString = nil;
    
    if (self.database.useFacebook)
    {
        NSString *facebookPredicate = [NSString stringWithFormat:predicateTemplate,kFacebook,self.database.facebookAccountUserID];
        predicateString = [NSString stringWithString:facebookPredicate];
    }

    if (self.database.useTwitter)
    {
        
        NSString *twitterPredicate = [NSString stringWithFormat:predicateTemplate,kTwitter,self.database.twitterAccountUserID];

        if (!predicateString)
        {
            predicateString = [NSString stringWithString:twitterPredicate];
        }
        else
        {
            predicateString = [NSString stringWithFormat:@"( %@ ) OR ( %@ )",predicateString,twitterPredicate];
        }
    }
    
    if (self.database.useInstagram)
    {
        // initialize instagram
        //[self.database openInstagramInViewController:self];
        NSString *instagramPredicate = [NSString stringWithFormat:predicateTemplate,kInstagram,self.database.instagramAccountUserID];

        if (!predicateString)
        {
            predicateString = [NSString stringWithString:instagramPredicate];
        }
        else
        {
            predicateString = [NSString stringWithFormat:@"( %@ ) OR ( %@ )",predicateString,instagramPredicate];
        }
    }
    
    if (!predicateString)
    {
        predicateString = @"postedBy.type == -1";
    }
    
    //NSLog(@"predicateString = %@",predicateString);
    
    // setup for the slider
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    //[self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    //[self.feedTableView addGestureRecognizer: self.revealViewController.panGestureRecognizer];

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:moPost];
    request.predicate = [NSPredicate predicateWithFormat:predicateString];

    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO] ];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.database.managedDocument.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    /*
    [self.database.managedDocument.managedObjectContext performBlock:^{
        NSLog(@"performBlock");
        //[Post addDummyToContext:self.database.managedDocument.managedObjectContext];
    }];
    */
    [self.progressBar setHidden:YES];
    [self.progressBar setProgress:0.0 animated:NO];
    
    self.nRefreshers = 0;

    self.facebookImageView.image = [UIImage imageNamed:@"Facebook-Logo-Small.tif"];
    self.instagramImageView.image = [UIImage imageNamed:@"Instagram-Logo-200.png"];
    self.twitterImageView.image = [UIImage imageNamed:@"Twitter-Logo-200-sq.png"];
    if (self.database.useFacebook)
    {
        self.facebookImageView.alpha = 1.0f;
    }
    else
    {
        self.facebookImageView.alpha = 0.2f;
    }
    if (self.database.useTwitter)
    {
        self.twitterImageView.alpha = 1.0f;
    }
    else
    {
        self.twitterImageView.alpha = 0.2f;
    }
    
    if (self.database.useInstagram)
    {
        self.instagramImageView.alpha = 1.0f;
    }
    else
    {
        self.instagramImageView.alpha = 0.2f;
    }
    //self.facebookImageView.backgroundColor = [UIColor greenColor];
    //self.facebookImageView.backgroundColor = [UIColor redColor];
    self.facebookImageView.tintColor = [UIColor redColor];

    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(startRefreshCycle) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //NSLog(@"%@ viewWillDisappear",[self class]);
    [self.updateTimer invalidate];
}

- (void)startRefresher
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        self.nRefreshers++;
        if (self.nRefreshers == 0)
        {
            [self.refreshController endRefreshing];
        }
        //NSLog(@"startRefresher: n = %d",self.nRefreshers);
    });
}

-(void)stopRefresher
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        self.nRefreshers--;
        if (self.nRefreshers == 0)
        {
            [self.refreshController endRefreshing];
        }
        //NSLog(@"stopRefresher: n = %d",self.nRefreshers);

    });
}

- (void)startRefreshCycle
{
    self.facebookReadDone = NO;
    self.twitterReadDone = NO;
    self.instagramReadDone = NO;

    [self refreshCycle];
}

- (void)refreshCycle
{
    NSDate *now = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
    self.database.lastUpdate = now;

    if (self.database.useInstagram && !self.instagramReadDone)
    {
        {
            [self startRefresher];
            if (self.database.instagramLoaded)
            {
                [self readInstagramFeed:self.refreshController andCursor:nil];
            }
            else
            {
                NSLog(@"instagram not loaded yet");
                [self stopRefresher];
            }
        }
        
    } // end useInstagram
    
    if (self.database.useTwitter && !self.twitterReadDone)
    {
        //[self.database openTwitterInViewController:self];
        //[self.database loadAllTwitterFriendsInViewController:self];
        [self startRefresher];
        if (self.database.twitterLoaded)
        {
            [self readTwitterFeedWithRefreshed:self.refreshController];
        }
        else
        {
            [self stopRefresher];
            NSLog(@"twitter not loaded yet");
        }
        
    } // end useTwitter
    
    
    if (self.database.useFacebook && !self.facebookReadDone)
    {
        
        [self startRefresher];
        
        if (self.database.facebookLoaded)
        {
            [self.progressBar setProgress:0.0];
            [self.progressBar setHidden:NO];
            NSMutableArray *friends = [[NSMutableArray alloc] init];
            [friends addObject:self.database.facebookFriends[3]];
            [friends addObject:self.database.facebookFriends[4]];
            [friends addObject:self.database.facebookFriends[5]];

            [friends addObject:[self.database.facebookFriends lastObject]];
            for (UserObject *usr in friends)
            {
                NSLog(@"friend 1: %@",usr.name);
            }
            [self readFacebookFeedForArray:friends atPosition:0 withRefresher:self.refreshController andCompletionHandler:^(BOOL success) {
                // do nothing
            }];
        }
        else
        {
            [self stopRefresher];
            NSLog(@"facebook not loaded yet");
        }
        
    } // end useFacebook
    
    // if no feeds are selected just stop the refresher and reset the counter...should be zero anyways...
    bool allFeeds = self.database.useFacebook || self.database.useInstagram || self.database.useTwitter;
    if (!allFeeds)
    {
        self.nRefreshers = 0;
        [self.refreshController endRefreshing];
    }

}

- (void)refresh:(UIRefreshControl *)sender
{
    
/*
   NSTimeInterval interval = [now timeIntervalSinceDate:self.database.lastUpdate];
    // dont update too often, every 60s seems good enough
    if (interval < 60)
    {
        [sender endRefreshing];
        return;
    }
 */
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeStyle:NSDateFormatterShortStyle];
    [format setDateStyle:NSDateFormatterShortStyle];
    NSString *str = [format stringFromDate:self.database.lastUpdate];
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:str];
    self.refreshController.attributedTitle = title;
    
    /*
    [self.database.managedDocument.managedObjectContext performBlock:^{
        NSLog(@"performBlock");
        Post *post = [Post addDummyToContext:self.database.managedDocument.managedObjectContext];
        NSLog(@"post.postedBy.name = %@",post.postedBy.name);
    }];
    */
    /*
     NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:moPost];
     //request.predicate = [NSPredicate predicateWithFormat:@"(postedBy.name == 'deadmau5') OR (postedBy.name == 'rickygervais')"];
     request.predicate = [NSPredicate predicateWithFormat:@"(postedBy.type == %d)",kTwitter];
     
     request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO] ];
     
     self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.database.managedDocument.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
     */
    
    [self startRefreshCycle];

}

- (void)readFacebookFeedForArray:(NSArray *)userArray atPosition:(int)n withRefresher:(UIRefreshControl *)sender andCompletionHandler:(void (^)(BOOL success))completion
{
    UserObject *usr = [userArray objectAtIndex:n];
    
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appID = infoDict[@"FacebookAppID"];
    
    NSArray * permissions = [NSArray arrayWithObjects:@"read_stream",
                             @"read_friendlists",
                             @"user_photos",
                             nil];
    
    NSDictionary *options = @{ ACFacebookPermissionsKey : permissions,
                               ACFacebookAudienceKey : ACFacebookAudienceFriends,
                               ACFacebookAppIdKey : appID };
    
    [self.database.account requestAccessToAccountsWithType:self.database.facebookAccountType options:options completion:^(BOOL granted, NSError *error)
     {
         if (!error)
         {
             if (granted)
             {
                 NSLog(@"facebook access read stream granted");

                 NSString *apiString = [NSString stringWithFormat:@"%@/%@/posts", kFacebookGraphRoot,usr.uid];
                 NSURL *request = [NSURL URLWithString:apiString];
                 
                 NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                 [parameters setObject:@"true" forKey:@"summary"];
                 
                 SLRequest *posts = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:request parameters:parameters];
                 posts.account = self.database.selectedFacebookAccount;
                 
                 [self.database startActivityIndicator];
                 [posts performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      [self.database stopActivityIndicator];

                      if (!error)
                      {
                          NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                          NSArray *json = [jsonDict objectForKey:@"data"];
                          //NSDictionary *pagingDict = [jsonDict objectForKey:@"paging"];
                          if (json.count)
                          {
                              //NSLog(@"json = %@",json);
                              
                              for (NSDictionary *jPost in json)
                              {
                                  [self.database.managedDocument.managedObjectContext performBlock:^{
                                      Post *post = [Post addFacebookPostToContext:self.database.managedDocument.managedObjectContext fromDictionary:jPost forUserObject:usr forAccountID:self.database.facebookAccountUserID];
                                      [Post readCommentsForFacebookPostID:post.postID withCompletionHandler:^(NSInteger nComments) {
                                          if (nComments != post.comments.integerValue)
                                          {
                                              post.comments = [NSNumber numberWithInteger:nComments];
                                          }
                                          [Post readLikesForFacebookPost:post.postID withCompletionHandler:^(NSInteger nLikes) {
                                              if (nLikes != post.likes.integerValue)
                                              {
                                                  post.likes = [NSNumber numberWithInteger:nLikes];
                                              }
                                          }];
                                      }];
                                  }];
                                  
                              }
                            
                          }
                          else
                          {
                              NSLog(@"No facebook posts: urlResponse: %@",urlResponse);
                              NSLog(@"jsonDict = %@",jsonDict);
                              NSLog(@"possible reason is old access token");
                              NSDictionary *errorDict = [jsonDict objectForKey:@"error"];
                              NSNumber *errorCode = [errorDict objectForKey:@"code"];
                              if (errorCode.intValue == 104)
                              {
                                  //renew access token
                                  [self.database.account renewCredentialsForAccount:self.database.selectedFacebookAccount completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                                      NSLog(@"renewed facebook access credentials");
                                  }];
                              }
                          }
                          
                      }
                      else
                      {
                          NSString *errorMessage = [NSString stringWithFormat:@"%@",[error localizedDescription]];
                          NSString *message = [NSString stringWithFormat:@"Facebook error: %@",errorMessage];
                          UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:message
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                            destructiveButtonTitle:nil
                                                                 otherButtonTitles:nil];
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [as showInView:self.view];
                          });
                          NSLog(@"Facebook error = %@",[error localizedDescription]);
                      }
                      int nextNumber = n+1;
                      float progress = (float)nextNumber/(float)userArray.count;
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [self.progressBar setProgress:progress animated:YES];
                      });
                      
                      if (nextNumber < userArray.count)
                      {
                          [self readFacebookFeedForArray:userArray atPosition:nextNumber withRefresher:sender andCompletionHandler:^(BOOL success) {
                                  // do nothing
                          }];
                      }
                      else
                      {
                          NSLog(@"done loading facebook posts");
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self.progressBar setHidden:YES];

                          });
                          
                          [self stopRefresher];
                          self.facebookReadDone = YES;
                          [self refreshCycle];
                      }
                  }];
                 
             }
             else
             {
                 UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"Facebook access not granted. Check permissions in Settings"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [as showInView:self.view];
                 });
             }
         }
         else
         {
             NSString *errorMessage = [NSString stringWithFormat:@"%@",[error localizedDescription]];
             NSString *message = [NSString stringWithFormat:@"Facebook error: %@",errorMessage];
             UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:message
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [as showInView:self.view];
             });
         }
     }
     ];
    

    //NSString *startPage = [NSString stringWithFormat:@"/%@/feed",uid];
    //NSString *startPage = @"/me/feed";

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeStyle:NSDateFormatterShortStyle];
    [format setDateStyle:NSDateFormatterShortStyle];
    NSString *str = [format stringFromDate:self.database.lastUpdate];
    [params setObject:str forKey:@"since"];

}

- (void)readTwitterFeedWithRefreshed:(UIRefreshControl *)sender
{
    [self.database.account requestAccessToAccountsWithType:self.database.twitterAccountType options:nil completion:^(BOOL granted, NSError *error)
    {
        if (granted)
        {
            
            ACAccount *twitterAccount = self.database.selectedTwitterAccount;
            NSString *username = [twitterAccount username];
            /*
            
            [self.database.account renewCredentialsForAccount:twitterAccount completion:^(ACAccountCredentialRenewResult renewResult, NSError *error)
            {
                NSLog(@"renewed credentials");
            }];
            */
            if (twitterAccount)
            {
                NSLog(@"here i am in twitter for %@",username);
                NSString *apiString = [NSString stringWithFormat:@"%@/%@/statuses/home_timeline.json", kTwitterAPIRoot, kTwitterAPIVersion];
                //NSString *apiString = [NSString stringWithFormat:@"%@/%@/statuses/user_timeline.json", kTwitterAPIRoot, kTwitterAPIVersion];

                NSURL *request = [NSURL URLWithString:apiString];
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                [parameters setObject:@"100" forKey:@"count"];
                [parameters setObject:@"1" forKey:@"include_entities"];
                //[parameters setObject:@"uid" forKey:@"user_id"];
                [parameters setObject:username forKey:@"screen_name"];
                SLRequest *posts = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:request parameters:parameters];
                
                posts.account = twitterAccount;
                
                [self.database startActivityIndicator];
                [posts performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error)
                 {
                     [self.database stopActivityIndicator];

                     //NSLog(@"response = %@",response);
                     //NSLog(@"error = %@",error.debugDescription);
                     if (!error)
                     {
                         NSArray *json = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];

                             if (json.count)
                             {

                                 for (NSDictionary *jPost in json)
                                 {
                                     [self.database.managedDocument.managedObjectContext performBlock:^{
                                         Post *post = [Post addTwitterPostToContext:self.database.managedDocument.managedObjectContext fromDictionary:jPost forUserID:self.database.twitterAccountUserID];
                                     }];
                                     
                                 }
                             }
                         /*
                         dispatch_async(dispatch_get_main_queue(), ^(void){
                             [self.feedTableView reloadData];
                         });
                          */
                         
                     }
                     else
                     {
                         NSLog(@"error = %@",[error localizedDescription]);
                     }
                     [self stopRefresher];
                     self.twitterReadDone = YES;
                     [self refreshCycle];

                 }];
            }
            else
            {
                NSLog(@"no twitter account");
                [self stopRefresher];
            }
            
        }
        else
        {
            NSLog(@"not granted");
            [self stopRefresher];
        }
    }];
}

- (void)readInstagramFeed:(UIRefreshControl *)sender andCursor:(NSString *)cursor
{
    bool addCursor = YES;
    if (!cursor || [cursor isEqualToString:@""])
    {
        addCursor = NO;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^ {
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *responseCode = nil;
        
        NSString *urlString = [NSString stringWithFormat:@"%@/users/self/feed?access_token=%@", kInstagramBaseURLString, self.database.instagramAccessToken];
        if (addCursor)
        {
            urlString = [NSString stringWithFormat:@"%@&cursor=%@",urlString,cursor];
        }
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        
        [self.database startActivityIndicator];
        NSData *pData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&responseCode error:&error];
        [self.database stopActivityIndicator];
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:pData options:NSJSONReadingMutableLeaves error:&error];
        
        //NSLog(@"result = %@",result);
        NSDictionary *metaDict = [result objectForKey:@"meta"];
        NSNumber *codeNumber = [metaDict objectForKey:@"code"];
        int codeInt = [codeNumber intValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (codeInt != 400)
            {
                
                NSArray *userData = [result objectForKey:@"data"];
                NSDictionary *pagination = [result objectForKey:@"pagination"];
                NSString *next_cursor = [pagination objectForKey:@"next_cursor"];
                
                for (NSDictionary *jPost in userData)
                {
                    // add it to core data
                    //NSLog(@"userDict = %@",userDict);
                    [self.database.managedDocument.managedObjectContext performBlock:^{
                        Post *post = [Post addInstagramPostToContext:self.database.managedDocument.managedObjectContext fromDictionary:jPost forUserID:self.database.instagramAccountUserID];
                    }];
                    
                }
                /*
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self.feedTableView reloadData];
                });
                */
                
                if (next_cursor)
                {
                    // load next sequence
                    //[self readInstagram:sendder withCursor:next_cursor];
                }
                
            }
            else
            {
                NSString *output = [NSString stringWithFormat:@"Instagram Authentication Error. No valid access token. Please log in."];
                UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:output
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:nil];
                
                [as showInView:self.view];
                
            }
            [self stopRefresher];
            self.instagramReadDone = YES;
            [self refreshCycle];
        });
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //[self.feedArray removeAllObjects];
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
    tifTableViewCell *cell = (tifTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if (!cell)
    {
        NSLog(@"cell is nil");
        cell = [[tifTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Post *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    User *user = post.postedBy;
    
    cell.usernameLabel.text = user.name;
    NSString *dateStr = [self.dateFormatter stringFromDate:post.date];

    cell.dateLabel.text = dateStr;
    cell.messageLabel.text = post.message;
    cell.likesLabel.text = [NSString stringWithFormat:@"%@",post.likes];
    cell.commentsLabel.text = [NSString stringWithFormat:@"%@",post.comments];
    cell.mainImage.image = nil;
    
    if (post.imageData)
    {
        cell.mainImage.image = [UIImage imageWithData:post.imageData];
    }
    else
    {
        if (post.imageURL || ![post.imageURL isEqualToString:@""])
        {
            [self downloadImageForPost:post AtIndexPath:indexPath];
        }
        else
        {
            kMediaTypes type = user.type.intValue;
            switch (type) {
                case kFacebook:
                    post.imageData = UIImagePNGRepresentation(self.database.facebookLogo);
                    cell.mainImage.image = self.database.facebookLogo;
                    break;
                case kInstagram:
                    cell.mainImage.image = self.database.instagramLogo;
                    break;
                case kTwitter:
                    post.imageData = UIImagePNGRepresentation(self.database.twitterLogo);
                    cell.mainImage.image = self.database.twitterLogo;
                    break;
                    
                default:
                    break;
            }
        }
        
    }
    cell.mainImage.contentMode = UIViewContentModeScaleAspectFit;
    //cell.mainImage.contentMode = UIViewContentModeScaleToFill;
    
    kMediaTypes type = user.type.intValue;
    
    // cant to this in a switch statement
    /*
    if (type == kFacebook)
    {
        [Post readCommentsForFacebookPostID:post.postID withCompletionHandler:^(NSInteger nComments) {
            post.comments = [NSNumber numberWithInteger:nComments];
            
            [Post readLikesForFacebookPost:post.postID withCompletionHandler:^(NSInteger nLikes) {
                post.likes = [NSNumber numberWithInteger:nLikes];
            }];
        }];
         
    }
    */
    switch (type) {
        case kFacebook:
            cell.typeImage.image = self.database.facebookLogo;
            cell.likesImage.image = [UIImage imageNamed:@"FB-ThumbsUp_29.png"];
            cell.commentsImage.image = [UIImage imageNamed:@"Basic-Speech-bubble-icon.png"];

            break;
            
        case kInstagram:
            cell.typeImage.image = self.database.instagramLogo;
            cell.likesImage.image = [UIImage imageNamed:@"favorite-5-24.png"];
            cell.commentsImage.image = [UIImage imageNamed:@"speech-bubble-24.png"];

            break;
        case kTwitter:
            cell.typeImage.image = self.database.twitterLogo;
            cell.likesImage.image = [UIImage imageNamed:@"favorite_on.png"];
            cell.commentsImage.image = [UIImage imageNamed:@"retweet_on.png"];
            
            break;
            
        default:
            break;
    }
    
    if (user.profileImageData)
    {
        cell.profileImage.image = [UIImage imageWithData:user.profileImageData];
    }
    else
    {
        [self downloadImageForUser:user AtIndexPath:indexPath];
    }

    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    return;
    /*
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
    */
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //DisplayObject *obj = [self.feedArray objectAtIndex:indexPath.row];
    //NSLog(@"link = %@",obj.link);
    //self.selectedLinkForWebview = obj.link;
    //[self performSegueWithIdentifier:@"weblinkSegue" sender:obj.link];

}

#pragma mark - Fetching

- (void)performFetch
{
    if (self.fetchedResultsController)
    {
        if (self.fetchedResultsController.fetchRequest.predicate)
        {
            if (self.debug) NSLog(@"[%@ %@] fetching %@ with predicate: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName, self.fetchedResultsController.fetchRequest.predicate);
        }
        else
        {
            if (self.debug) NSLog(@"[%@ %@] fetching all %@ (i.e., no predicate)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName);
        }
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    }
    else
    {
        if (self.debug) NSLog(@"[%@ %@] no NSFetchedResultsController (yet?)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    [self.feedTableView reloadData];
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    if (newfrc != oldfrc)
    {
        _fetchedResultsController = newfrc;
        newfrc.delegate = self;
        if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title))
        {
            self.title = newfrc.fetchRequest.entity.name;
        }
        if (newfrc)
        {
            if (self.debug) NSLog(@"[%@ %@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), oldfrc ? @"updated" : @"set");
            [self performFetch];
        }
        else
        {
            if (self.debug) NSLog(@"[%@ %@] reset to nil", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            [self.feedTableView reloadData];
        }
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        [self.feedTableView beginUpdates];
        self.beganUpdates = YES;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.feedTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.feedTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{

    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.feedTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.feedTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self.feedTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeMove:
                [self.feedTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.feedTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.beganUpdates) [self.feedTableView endUpdates];
}

- (void)endSuspensionOfUpdatesDueToContextChanges
{
    _suspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
}

- (void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)suspend
{
    if (suspend)
    {
        _suspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
    }
    else
    {
        [self performSelector:@selector(endSuspensionOfUpdatesDueToContextChanges) withObject:0 afterDelay:0];
    }
}

# pragma mark prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"prepareForSegue: segue %@",segue.identifier);
    
    if ([segue.identifier isEqualToString:@"weblinkSegue"])
    {

        linkWebViewController *vc = (linkWebViewController *)segue.destinationViewController;
        //NSString *urlString = @"http://www.google.com";
        NSLog(@"link = %@",self.selectedLinkForWebview);
        [vc setUrlString:self.selectedLinkForWebview];
    }
}

- (void)downloadImageForUser:(User *)user AtIndexPath:(NSIndexPath *)indexPath
{
    
    NSURL *url = [NSURL URLWithString:user.profileImageURL];
    NSMutableURLRequest *pictureRequest = [NSMutableURLRequest requestWithURL:url];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    __weak User *weakUser = user;
    __block NSData *pImageData = nil;
    dispatch_async(queue, ^ {
        NSHTTPURLResponse *responseCode = nil;
        NSError *error = [[NSError alloc] init];
        [self.database startActivityIndicator];
        pImageData = [NSURLConnection sendSynchronousRequest:pictureRequest returningResponse:&responseCode error:&error];

        [self.database stopActivityIndicator];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            if (pImageData)
            {
                weakUser.profileImageData = pImageData;
                [self.feedTableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        });
        
    });

}

- (void)downloadImageForPost:(Post *)post AtIndexPath:(NSIndexPath *)indexPath
{
    
    NSURL *url = [NSURL URLWithString:post.imageURL];
    NSMutableURLRequest *pictureRequest = [NSMutableURLRequest requestWithURL:url];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __weak Post *weakPost = post;
    __block NSData *pImageData = nil;
    dispatch_async(queue, ^ {
        NSHTTPURLResponse *responseCode = nil;
        NSError *error = [[NSError alloc] init];
        [self.database startActivityIndicator];
        pImageData = [NSURLConnection sendSynchronousRequest:pictureRequest returningResponse:&responseCode error:&error];
        
        [self.database stopActivityIndicator];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            if (pImageData)
            {
                weakPost.imageData = pImageData;
                [self.feedTableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        });
        
    });
    
}

@end
