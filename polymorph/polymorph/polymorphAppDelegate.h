//
//  polymorphAppDelegate.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "polymorphViewController.h"

@interface polymorphAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIView *statusBarView;
@property (weak, nonatomic) polymorphViewController *pvc;
@end
