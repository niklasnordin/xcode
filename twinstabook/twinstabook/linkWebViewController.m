//
//  linkWebViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-13.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "linkWebViewController.h"

@interface linkWebViewController ()

@end

@implementation linkWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        // init
    }
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // init
        //self.urlString = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //NSString *urlString = @"http://www.google.com";
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    NSLog(@"loading request %@",self.urlString);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
