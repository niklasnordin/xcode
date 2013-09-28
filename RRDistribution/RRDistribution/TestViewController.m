//
//  TestViewController.m
//  RRDistribution
//
//  Created by Niklas Nordin on 2013-09-28.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

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
    _nSamplesTextField.delegate = self;
    _lambdaTextField.delegate = self;
    _kTextField.delegate = self;
    
    //[self.tabBarController]
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pasteButtonPressed:(id)sender
{
    NSLog(@"paste pressed");
}

- (IBAction)TestButtonPressed:(id)sender
{
    int iterations = [[self.nSamplesTextField text] intValue];
    NSLog(@"iterations = %d",iterations);
    //float smd = 0.0;
    //float dv90 = 0.0;
    
    for (int i=1; i<=iterations; i++)
    {
        float f = [self.function sample:i];
        
        NSLog(@"i=%d, %f",i,f);
        [self.iterationLabel setText:[NSString stringWithFormat:@"%d", i]];
        usleep(10000);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
