//
//  NNViewControllerViewController.h
//  slideViewControllerExample
//
//  Created by Niklas Nordin on 2014-02-17.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNViewControllerViewController : UIViewController

@end


// This will allow the class to be defined on a storyboard
#pragma mark - SWRevealViewControllerSegue

@interface NNViewControllerSegue : UIStoryboardSegue

@property (strong) void(^performBlock)( NNViewControllerSegue* segue, UIViewController* svc, UIViewController* dvc );

@end
