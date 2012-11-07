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
    NSLog(@"view did load");
    [super viewDidLoad];
    _pictureView.delegate = self;
    [_pictureView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:_pictureView action:@selector(pan:)]];

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:_pictureView action:@selector(tap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [_pictureView addGestureRecognizer:tapRecognizer];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"view did appear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)choiceButtonPressed:(UIButton *)sender
{
    NSLog(@"choiceButtonPressed");
    NSLog(@"tag = %d, %@",sender.tag,sender.restorationIdentifier);
    [_pictureView clearPicture];

}

-(void)setDisplayWithText:(NSString *)text
{
    _display.text = text;
}

-(void)setScoreWithInt:(int)score
{
    _scoreField.text = [[NSString alloc] initWithFormat:@"%d",score];
}

@end
