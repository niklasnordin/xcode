//
//  commentVC.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-18.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "commentVC.h"
#import "setPropertyViewController.h"

@interface commentVC ()

@end

@implementation commentVC

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
    _commentTextView.delegate = self;
    _commentTextView.text = _comment;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setCommentTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    //NSLog(@"comment view unloaded");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    _comment = [textView text];
    [_dict setObject:_comment forKey:@"comment"];
    //NSString *specie = [self.presentingViewController specie];

    return YES;
}

@end
