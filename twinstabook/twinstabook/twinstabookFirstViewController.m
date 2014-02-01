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
    NSLog(@"page = %@",page);
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSTimeInterval interval = -86400*7000;
    NSDate *start = [[NSDate alloc] initWithTimeIntervalSinceNow:interval];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeStyle:NSDateFormatterShortStyle];
    [format setDateStyle:NSDateFormatterShortStyle];
    NSString *str = [format stringFromDate:start];
    NSLog(@"str date : %@",str);
    [params setObject:str forKey:@"since"];
    [FBRequestConnection startWithGraphPath:page parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *conn, id result, NSError *error)
    {
        if (!error)
        {
            NSArray *data = [result objectForKey:@"data"];
            [self writeStories:data];
            FBGraphObject *paging = [result objectForKey:@"paging"];
        
            NSString *previous = [paging objectForKey:@"previous"];
            NSString *next = [paging objectForKey:@"next"];
            [self readURL:previous fromConnection:connection next:NO];
            [self readURL:next fromConnection:connection next:YES];
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
