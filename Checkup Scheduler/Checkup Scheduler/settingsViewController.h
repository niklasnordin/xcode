//
//  settingsViewController.h
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-07-13.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "settingsDB.h"

@interface settingsViewController : UIViewController

@property (weak, nonatomic) settingsDB *preferences;

@end
