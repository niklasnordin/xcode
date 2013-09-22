//
//  MCSchedulerAppDelegate.h
//  MCScheduler
//
//  Created by Niklas Nordin on 9/22/13.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSchedulerViewController.h"

@interface MCSchedulerAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (weak, nonatomic) MCSchedulerViewController *appView;


@end
