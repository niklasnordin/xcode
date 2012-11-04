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
	// Do any additional setup after loading the view, typically from a nib.
    _pictureView.delegate = self;
    [_pictureView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:_pictureView action:@selector(pan:)]];
    //NSLog(@"pictureView.frame = w=%g, h=%g",_pictureView.frame.size.width,_pictureView.frame.size.height);
    //NSLog(@"pictureView.or x=%g, y=%g",_pictureView.frame.origin.x, _pictureView.frame.origin.y);
    
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear, w = %f",_pictureView.frame.size.width);
    /*
    _pictureView.bgView = [[UIImageView alloc] initWithImage:_pictureView.bgImage];
    _pictureView.bgView.contentMode = UIViewContentModeScaleToFill;
    [_pictureView addSubview:_pictureView.bgView];
    [_pictureView sendSubviewToBack:_pictureView.bgView];
    _pictureView.bgImageRef = _pictureView.bgImage.CGImage;
     */

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDisplayWithText:(NSString *)text
{
    _display.text = text;
}

@end
