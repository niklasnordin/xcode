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
    [_commentTextView becomeFirstResponder];
    self.commentTextView.text = self.comment;
	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Release any retained subviews of the main view.
    //NSLog(@"comment text view %@",[self.commentTextView text]);
    [self.dict setObject:[self.commentTextView text] forKey:@"comment"];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

@end
