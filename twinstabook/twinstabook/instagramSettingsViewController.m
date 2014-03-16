//
//  instagramSettingsViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-19.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "instagramSettingsViewController.h"

@interface instagramSettingsViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (weak, nonatomic) IBOutlet UISwitch *instagramSwitch;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)clickedInstagramSwitch:(UISwitch *)sender;
- (IBAction)logoutButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logoutButtonLabel;
@property (weak, nonatomic) IBOutlet UILabel *loggedInAsLabel;
@end

@implementation instagramSettingsViewController

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
	// Do any additional setup after loading the view.
    
    self.webView.delegate = self;
    //self.webView.scrollView.scrollEnabled = NO;
    // setup for the slider
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];

    [self.instagramSwitch setOn:self.db.useInstagram];
    [self.webView setHidden:YES];
    [self.logoutButtonLabel setHidden:YES];
    [self.loggedInAsLabel setHidden:YES];
    
    if (self.db.useInstagram)
    {
        [self checkIfAccessTokenIsValidwithCompletionsHandler:^(NSString *username) {
            [self.loggedInAsLabel setHidden:NO];
            [self.loggedInAsLabel setText:[NSString stringWithFormat:@"Logged in as: %@",username]];
        }];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedInstagramSwitch:(UISwitch *)sender
{
    self.db.useInstagram = sender.on;
    
    if (self.db.useInstagram)
    {
        [self checkIfAccessTokenIsValidwithCompletionsHandler:^(NSString *username) {
            [self.loggedInAsLabel setHidden:NO];
            [self.loggedInAsLabel setText:[NSString stringWithFormat:@"Logged in as: %@",username]];
        }];
        //[self.db openInstagramInViewController:self andWebView:self.webView];
    }
    else
    {
        [self.webView setHidden:YES];
        [self.logoutButtonLabel setHidden:YES];
        [self.loggedInAsLabel setHidden:YES];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *numberInstagram = [[NSNumber alloc] initWithBool:self.db.useInstagram];
    [defaults setObject:numberInstagram forKey:USEINSTAGRAM];
    [defaults synchronize];
}

- (IBAction)logoutButton:(id)sender
{
    NSString *urlString = [NSString stringWithFormat:@"https://instagram.com/accounts/logout/"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    self.db.instagramAccessToken = @"";
    [self.logoutButtonLabel setHidden:YES];
    [self.loggedInAsLabel setHidden:YES];
    [self.webView setHidden:NO];
}

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
                navigationType:(UIWebViewNavigationType)navigationType
{
    //NSLog(@"This is it... %@",request.URL.absoluteString);

    if ([request.URL.absoluteString rangeOfString:@"#"].location != NSNotFound)
    {
        NSString* params = [[request.URL.absoluteString componentsSeparatedByString:@"#"] objectAtIndex:1];
        //NSLog(@"params = %@",params);

        self.db.instagramAccessToken = [params stringByReplacingOccurrencesOfString:@"access_token=" withString:@""];
        //self.webView.hidden = YES;
        [self.logoutButtonLabel setHidden:NO];
        [self.loggedInAsLabel setHidden:NO];
        [self.webView setHidden:YES];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.db.instagramAccessToken forKey:INSTAGRAMACCESSTOKEN];
        [defaults synchronize];

    }
    
    if ([request.URL.absoluteString isEqualToString:@"http://instagram.com/"])
    {
        NSLog(@"loadLoginScreen");
        [self loadLoginScreen];
    }
    
	return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    if ([self.db.instagramAccessToken length] > 1)
    {
        [self checkIfAccessTokenIsValidwithCompletionsHandler:^(NSString *username) {
            [self.loggedInAsLabel setHidden:NO];
            [self.loggedInAsLabel setText:[NSString stringWithFormat:@"Logged in as: %@",username]];
        }];
    }
}

- (void)loadLoginScreen
{
    NSString *urlString = [NSString stringWithFormat:@"https://instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token",kInstagramClientId, kInstagramRedirectUrl];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

- (void)checkIfAccessTokenIsValidwithCompletionsHandler:(void (^)(NSString *username))completion;
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^ {
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *responseCode = nil;
    
        NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/?access_token=%@",self.db.instagramAccessToken];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        NSData *pData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&responseCode error:&error];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:pData options:NSJSONReadingMutableLeaves error:&error];
    
        //NSLog(@"result = %@",result);
        NSDictionary *metaDict = [result objectForKey:@"meta"];
        NSNumber *codeNumber = [metaDict objectForKey:@"code"];
        int codeInt = [codeNumber intValue];
        //NSLog(@"code = %@",codeNumber);
        dispatch_async(dispatch_get_main_queue(), ^ {
            
            if (codeInt != 400)
            {
                //NSLog(@"it is valid");
                NSDictionary *dataDict = [result objectForKey:@"data"];
                //NSLog(@"dataDict = %@",dataDict);
                NSString *username = [dataDict objectForKey:@"username"];
                
                //NSString *profileLinkURL = [dataDict objectForKey:@"profile_picture"];
                //NSString *userid = [dataDict objectForKey:@"id"];
            

                [self.webView setHidden:YES];
                [self.logoutButtonLabel setHidden:NO];
                completion(username);
            }
            else
            {
                NSLog(@"it is not valid");
            
                [self.webView setHidden:NO];
                [self.loggedInAsLabel setHidden:YES];
                [self.logoutButtonLabel setHidden:YES];
                [self loadLoginScreen];

            }
        });
    });
    
}

@end
