//
//  checkupSchedulerAppDelegate.h
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-06-21.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "checkupSchedulerViewController.h"

@interface checkupSchedulerAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (weak, nonatomic) checkupSchedulerViewController *appView;

@end
