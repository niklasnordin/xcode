//
//  twinstabookFirstViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-17.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "twinstabookFirstViewController.h"
#import "FacebookParser2.h"
#import "displayObject.h"

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
    
    self.picker = [[JMPickerView alloc] initWithDelegate:self addingToViewController:self withDistanceToTop:20.0f];
    [self.picker hide:-1.0f];
    [self.feedButton setTitle:[self nameForPicker:self.database.selectedFeedIndex] forState:UIControlStateNormal];
    [self.picker selectRow:self.database.selectedFeedIndex inComponent:0 animated:NO];
 
    // setup the refresh controller for the tableview
    self.refreshController = [[UIRefreshControl alloc] init];
    [self.refreshController addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.feedTableView addSubview:self.refreshController];
}

- (void)refresh:(UIRefreshControl *)sender
{
    NSLog(@"refreshing....hello");
    [sender endRefreshing];
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
            
            //NSString *story = [k objectForKey:@"type"];
            //NSString *from = [k objectForKey:@"from"];
            //NSArray *allk = [k allKeys];
            //NSLog(@"story = %@",story);
            //self.textView.text = [NSString stringWithFormat:@"%@\n\n%@",self.textView.text,k];
            self.textView.text = [NSString stringWithFormat:@"%@\n\n%@",self.textView.text,obj.main];
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
            FBGraphObject *paging = [result objectForKey:@"paging"];
        
            NSString *previous = [paging objectForKey:@"previous"];
            NSString *next = [paging objectForKey:@"next"];
            [self readURLAsync:previous fromConnection:connection next:NO];
            [self readURLAsync:next fromConnection:connection next:YES];
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
    self.textView.text = @"";
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
        //NSString *startPage = @"search?q=max&type=user";
        [self readSession:session fromConnection:conn fromPage:startPage];

        
    } // end useFacebook
    
    if (self.database.useInstagram)
    {
        
    } // end useInstagram
    
    if (self.database.useTwitter)
    {
        
    } // end useTwitter
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
}

- (void)pickerViewSelectionIndicatorWasTapped:(JMPickerView *)pickerView
{
    //NSLog(@"picker indicator tapped");
    [self.picker hide:0.3f];
}

- (NSString *)nameForPicker:(NSInteger)index
{
    NSString *name = @"me";
    
    if (index > 0)
    {
        name = [self.database.groups objectAtIndex:index-1];
    }
    return name;
}

@end
