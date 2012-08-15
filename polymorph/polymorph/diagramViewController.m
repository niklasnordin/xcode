//
//  diagramViewController.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-25.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "diagramViewController.h"
#import "diagramView.h"

@interface diagramViewController ()

@end

@implementation diagramViewController

-(void)setup:(id <functionValue>)f
        dict:(NSDictionary *)dict
         min:(double)xmin
         max:(double)xmax
    pressure:(double)p
{
    [self setFunction:f];
    _dict = dict;
    _xMin = xmin;
    _xMax = xmax;
    _pressure = p;
}

-(void) setDview:(diagramView *)dview
{
    //NSLog(@"setDview");
    _dview = dview;
    [_dview addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.dview action:@selector(pan:)]];
    [_dview addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.dview action:@selector(pinch:)]];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.dview action:@selector(tap:)];
    tapRecognizer.numberOfTapsRequired = 2;
    [_dview addGestureRecognizer:tapRecognizer];
    
    [_dview setFunction:_function];
    [_dview setDict:_dict];
    [_dview setPressure:_pressure];
    [_dview setup:self.xMin max:self.xMax];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setDview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
