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
    
    // setup for the slider
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];

    [self.instagramSwitch setOn:self.db.useTwitter];
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
        [self.db openInstagramInViewController:self andWebView:self.webView];
    }
}

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
                navigationType:(UIWebViewNavigationType)navigationType
{
    
    if ([request.URL.absoluteString rangeOfString:@"#"].location != NSNotFound)
    {
        NSString* params = [[request.URL.absoluteString componentsSeparatedByString:@"#"] objectAtIndex:1];
        self.db.instagramAccessToken = [params stringByReplacingOccurrencesOfString:@"access_token=" withString:@""];
        //self.webView.hidden = YES;

        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.db.instagramAccessToken forKey:INSTAGRAMACCESSTOKEN];
        [defaults synchronize];

    }
    
	return YES;
}

@end
