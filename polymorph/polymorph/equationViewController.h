//
//  equationViewController.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-24.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "setPropertyViewController.h"

@interface equationViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic) int functionIndex;
@property (strong, nonatomic) NSArray *functionNames;
@property (strong, nonatomic) setPropertyViewController *spVC;

@property (strong, nonatomic) NSString *equation;

- (void)swipeGesture:(UISwipeGestureRecognizer *)gesture;
- (void)pan:(UIPanGestureRecognizer *)gesture;


@end
