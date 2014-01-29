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

- (void)readURL:(NSString *)urlString
{
    NSLog(@"url = %@",urlString);

    if (urlString)
    {
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        //[urlRequest setHTTPMethod:@"GET"];
        
        NSURLResponse *response;
        NSError *err;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&err];
        FBGraphObject *obj = [responseData bytes];
        NSString *content = [NSString stringWithUTF8String:[responseData bytes]];
        
        //NSLog(@"responseData: %@", content);

    }
}

- (void)readSession:(FBSession *)session fromConnection:(FBRequestConnection *)connection fromPage:(NSString *)page
{
    NSLog(@"page = %@",page);
    FBRequest *request = [[FBRequest alloc] initWithSession:session graphPath:page];

    [connection addRequest:request completionHandler:^(FBRequestConnection *conn, id result, NSError *error)
     {
         if (!error)
         {
             NSLog(@"result class = %@",[result class]);

             //NSArray *data = [result objectForKey:@"data"];
             FBGraphObject *paging = [result objectForKey:@"paging"];
         
             //NSString *previous = [paging objectForKey:@"previous"];
             NSString *next = [paging objectForKey:@"next"];
             //NSLog(@"in next = %@",next);
             [self readURL:next];
         }
         else
         {
             NSLog(@"connection failed. error = %@",error);
         }
         
     }
    ];
    [connection start];
}

- (IBAction)updateButtonClicked:(id)sender
{

    if (self.database.useFacebook)
    {
        FBSession *session = [FBSession activeSession];

        if (session.isOpen)
        {
            NSLog(@"FB session is open");
            //FBAccessTokenData *data = FBSession.activeSession.accessTokenData;
            //NSLog(@"permissions = %@",data.permissions);
        }
        else
        {
            NSLog(@"FB session is NOT open");
            return;
        }
        FBRequestConnection* conn = [[FBRequestConnection alloc] init];

        [self readSession:session fromConnection:conn fromPage:@"/me/feed"];
        NSLog(@"return");
        return;
        
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
            FBRequestConnection* conn = [[FBRequestConnection alloc] init];
            FBRequest *request = [[FBRequest alloc] initWithSession:session graphPath:@"/me/feed"];
           // __block NSString *next;
            [conn addRequest:request completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
            {
                
                NSLog(@"result class = %@",[result class]);
                NSArray *data = [result objectForKey:@"data"];
                FBGraphObject *paging = [result objectForKey:@"paging"];
                 
                for (NSDictionary *k in data)
                {
                     NSString *story = [k objectForKey:@"story"];
                     //NSString *from = [k objectForKey:@"from"];
                     NSLog(@"story = %@",story);
                }
                 
                //NSString *previous = [paging objectForKey:@"previous"];
                NSString *next = [paging objectForKey:@"next"];
                NSLog(@"next step");
                NSURL *url = [NSURL URLWithString:next];
                NSLog(@"url = %@",url);
                NSMutableURLRequest *nextRequest = [NSMutableURLRequest requestWithURL:url];
                //FBRequestHandler *handler;
                //[connection setUrlRequest:nextRequest];
                //[connection start];
                //NSHTTPURLResponse *response = [connection urlResponse];
                //NSLog(@"response = %@",response);
            }
            ];
            [conn start];
            NSLog(@"here i am");
/*
            [FBRequestConnection startWithGraphPath:@"/me/feed" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
             {

                 NSArray *data = [result objectForKey:@"data"];
                 FBGraphObject *paging = [result objectForKey:@"paging"];
                 
                 for (NSDictionary *k in data)
                 {
                     NSString *story = [k objectForKey:@"story"];
                     NSString *from = [k objectForKey:@"from"];
                     NSLog(@"story = %@",story);
 
                     NSArray *dataKeys = [k allKeys];
                     NSLog(@"new keys -------");
                     for (NSString *ko in dataKeys)
                     {
                         NSLog(@"data key = %@",ko);
                         NSLog(@"%@", [k objectForKey:ko]);
                     }
 
                 }

                 NSString *previous = [paging objectForKey:@"previous"];
                 NSString *next = [paging objectForKey:@"next"];
                 
                 if (next)
                 {
                     NSLog(@"hej... %@");
                     NSURL *url = [NSURL URLWithString:next];
                     NSMutableURLRequest *nextRequest = [NSMutableURLRequest requestWithURL:url];
                     
                     //connection.urlRequest = nextRequest;
                     [connection setUrlRequest:nextRequest];
                     [connection start];
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
 */
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
