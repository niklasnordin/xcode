//
//  equationScrollVC.m
//  polymorph
//
//  Created by Niklas Nordin on 2013-09-17.
//  Copyright (c) 2013 nequam. All rights reserved.
//

#import "equationScrollVC.h"

@interface equationScrollVC ()

@end

@implementation equationScrollVC

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
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    int nImages = 4;
    CGRect imageRect = _scrollView.bounds;
    CGSize allImageSize = CGSizeMake(nImages*imageRect.size.width, imageRect.size.height);
    _scrollView.contentSize = allImageSize;

    for (int i=0; i<nImages; i++)
    {
        NSString *name = _functionNames[i];
        UIImageView *image = [[UIImageView alloc] initWithFrame:imageRect];
        [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",name]]];
        [image setContentMode:UIViewContentModeScaleAspectFit];
        [image sizeThatFits:_scrollView.bounds.size];
        [_scrollView addSubview:image];
        imageRect = CGRectOffset(imageRect, _scrollView.bounds.size.width, 0);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setBarButtonPressed:(id)sender
{
    NSLog(@"set Pressed");
}
@end
