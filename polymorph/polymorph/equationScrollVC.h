//
//  equationScrollVC.h
//  polymorph
//
//  Created by Niklas Nordin on 2013-09-17.
//  Copyright (c) 2013 nequam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "setPropertyViewController.h"

@interface equationScrollVC : UIViewController

@property (nonatomic) int functionIndex;
@property (weak, nonatomic) NSArray *functionNames;
@property (weak, nonatomic) setPropertyViewController *spVC;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)setBarButtonPressed:(id)sender;

@end
