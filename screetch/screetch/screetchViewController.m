//
//  thermoViewViewController.m
//  screetch
//
//  Created by Niklas Nordin on 2012-10-23.
//  Copyright (c) 2012 Niklas Nordin. All rights reserved.
//

#import "screetchViewController.h"

@interface screetchViewController ()

@end

@implementation screetchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pictureView.delegate = self;
    
    _categories = @[ @"people", @"places", @"animals", @"things" ];
    _animals = @[ @"cat", @"dog", @"pig" ];
    
    NSString *http = @"http://www.nequam.se/screetch";
    [self loadRandomPictureFromURL:http];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)choiceButtonPressed:(UIButton *)sender
{
    [_pictureView clearAndAnimatePicture];
    usleep(5000);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You selected R" message:@"correct?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil];
    
    alert.delegate = self;
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    //[alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    /*
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.delegate = self;
    [tf setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tf setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    //tf.text = [[NSString alloc] initWithFormat:@"%@", num];
    */
    [alert show];
    
}

-(void)setDisplayWithText:(NSString *)text
{
    _display.text = text;
}

-(void)setScoreWithInt:(int)score
{
    _scoreField.text = [[NSString alloc] initWithFormat:@"%d",score];
}

-(void)loadRandomPictureFromURL:(NSString *)name
{
    NSString *http = @"/Users/niklasnordin";
    NSURL *url = [NSURL URLWithString:http];

    NSArray *categories = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:name error:NULL];
    NSLog(@"categories = %@",categories);
}
@end
