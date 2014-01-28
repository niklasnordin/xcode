//
//  twinstabookFirstViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-17.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "twinstabookFirstViewController.h"

@interface twinstabookFirstViewController ()

@end

@implementation twinstabookFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad");
    self.appDelegate = (twinstabookAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!self.appDelegate.database)
    {
        self.appDelegate.database = [[tif_db alloc] init];
        self.database = self.appDelegate.database;
    }
    self.textView.scrollEnabled = YES;
    self.textView.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateButtonClicked:(id)sender
{
    NSLog(@"update button clicked");
    if (self.database.useFacebook)
    {
        if (FBSession.activeSession.isOpen)
        {
            NSLog(@"FB session is open");
            FBAccessTokenData *data = FBSession.activeSession.accessTokenData;
            NSLog(@"permissions = %@",data.permissions);
        }
        else
        {
            NSLog(@"FB session is NOT open");
        }
        /*
        NSString *fqlQuery = @"SELECT post_id, created_time,  type, attachment FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid=me() AND type='newsfeed')AND is_hidden = 0 LIMIT 300";
    
        // Make the API request that uses FQL
        [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:[NSDictionary dictionaryWithObjectsAndKeys: fqlQuery, @"q", nil]
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error)
         {
             if (error)
                 NSLog(@"Error: %@", [error localizedDescription]);
             else
                 NSLog(@"Result: %@", result);
         }];
         */
        {
            //FBRequestConnection* conn = [[FBRequestConnection alloc] init];
            [FBRequestConnection startWithGraphPath:@"/me" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
             {
                 //NSLog(@"me = %@",result);
             }];
        }
        {
            //FBRequestConnection* conn = [[FBRequestConnection alloc] init];
            [FBRequestConnection startWithGraphPath:@"/me/feed" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
             {

                 NSArray *data = [result objectForKey:@"data"];
                 FBGraphObject *paging = [result objectForKey:@"paging"];
                 
                 for (NSDictionary *k in data)
                 {
                     NSString *story = [k objectForKey:@"story"];
                     NSString *from = [k objectForKey:@"from"];
                     NSLog(@"story = %@",story);
                     /*
                     NSArray *dataKeys = [k allKeys];
                     NSLog(@"new keys -------");
                     for (NSString *ko in dataKeys)
                     {
                         NSLog(@"data key = %@",ko);
                         NSLog(@"%@", [k objectForKey:ko]);
                     }
                      */
                 }

                 NSString *previous = [paging objectForKey:@"previous"];
                 NSString *next = [paging objectForKey:@"next"];
                 
                 if (next)
                 {
                     NSLog(@"hej...");
                     
                     [FBRequestConnection startWithGraphPath:next completionHandler:^(FBRequestConnection *nextConnection, id nextResult, NSError *nextError)
                      {
                          NSUInteger num = [result count];
                          int n = (int)num;
                          NSLog(@"num = %d",n);
                          NSEnumerator *keys = [nextResult keyEnumerator];
                          for (NSString *a in keys)
                          {
                              NSLog(@"a = %@",a);
                          }
                          NSArray *nextData = [nextResult objectForKey:@"data"];
                          FBGraphObject *nextPage = [nextResult objectForKey:@"paging"];
                          for (NSDictionary *k in nextData)
                          {
                              NSString *story = [k objectForKey:@"story"];
                              NSString *from = [k objectForKey:@"from"];
                              NSLog(@"story = %@",story);
                          }
                          NSString *nextNext = [nextPage objectForKey:@"next"];
                      }];
                      
                 }
                 NSLog(@"då...");
                 //NSMutableDictionary<FBGraphObject> *graph = result;
                 //NSArray *keys = [graph allKeys];
                 //NSLog(@"result class = %@",[result class]);
                 //NSLog(@"me/feed %@",result);
                 //NSLog(@"keys = %@", keys);
                 //self.textView.text = keys;
                 //NSLog(@"data = %@",[graph objectForKey:@"data"]);
                 //NSString *data = [NSString stringWithFormat:@"data = %@\n",[graph objectForKey:@"data"]];
                 //NSString *text = [NSString stringWithFormat:@"%@ paging = %@",data, [graph objectForKey:@"paging"]];
                 //self.textView.text = text;

             }];
        }
    } // end useFacebook
    
    if (self.database.useInstagram)
    {
        
    } // end useInstagram
    
    if (self.database.useTwitter)
    {
        
    } // end useTwitter
}
@end
