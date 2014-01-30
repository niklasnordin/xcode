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

- (void)writeStories:(NSArray *)data
{
    if (data)
    {
        for (FBGraphObject *k in data)
        {
            NSString *story = [k objectForKey:@"story"];
            //NSString *from = [k objectForKey:@"from"];
            NSLog(@"story = %@",story);
        }
    }
    
}

- (void)readURL:(NSString *)urlString fromConnection:(FBRequestConnection *)connection
{
    //NSLog(@"urlString = %@", urlString);
    if (urlString)
    {
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        /*
        FBRequestHandler handler =
        ^(FBRequestConnection *connection, id result, NSError *error) {
            // output the results of the request
            [self requestCompleted:connection forFbID:fbid result:result error:error];
        };
        
        // create the request object, using the fbid as the graph path
        // as an alternative the request* static methods of the FBRequest class could
        // be used to fetch common requests, such as /me and /me/friends
        FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession
                                                      graphPath:fbid];
        
        // add the request to the connection object, if more than one request is added
        // the connection object will compose the requests as a batch request; whether or
        // not the request is a batch or a singleton, the handler behavior is the same,
        // allowing the application to be dynamic in regards to whether a single or multiple
        // requests are occuring
        [newConnection addRequest:request completionHandler:handler];
        */
        //NSString *newAPI = [urlString stringByReplacingOccurrencesOfString:@"https://graph.facebook.com/" withString:@""];

        //FBRequest *rq = [[FBRequest alloc] initWithSession:[FBSession activeSession] restMethod:urlString parameters:nil HTTPMethod:@"GET"];
        FBRequest *request = [FBRequest requestWithGraphPath:urlString parameters:nil HTTPMethod:@"GET"];
        [connection addRequest:request completionHandler:^(FBRequestConnection *conn, id result, NSError *error)
         {
             if (!error)
             {
                 NSLog(@"no error = %@",urlString);
                 NSArray *data = [result objectForKey:@"data"];
                 [self writeStories:data];
             }
             else
             {
                 NSLog(@"error: %@",error);
             }
         }
         ];
 
        //[connection setUrlRequest:urlRequest];
        [connection start];

    }
}

- (void)readSession:(FBSession *)session fromConnection:(FBRequestConnection *)connection fromPage:(NSString *)page
{
    NSLog(@"page = %@",page);

    [FBRequestConnection startWithGraphPath:page parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *conn, id result, NSError *error)
    {
        if (!error)
        {
            NSArray *data = [result objectForKey:@"data"];
            [self writeStories:data];
            FBGraphObject *paging = [result objectForKey:@"paging"];
        
            NSString *previous = [paging objectForKey:@"previous"];
            NSString *next = [paging objectForKey:@"next"];
        
            [self readURL:previous fromConnection:connection];
            [self readURL:next fromConnection:connection];
        }
        else
        {
            NSLog(@"error: %@",error);
        }
    }
    ];

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
        NSString *startPage = @"/me/feed";
        [self readSession:session fromConnection:conn fromPage:startPage];

        
    } // end useFacebook
    
    if (self.database.useInstagram)
    {
        
    } // end useInstagram
    
    if (self.database.useTwitter)
    {
        
    } // end useTwitter
}
@end
