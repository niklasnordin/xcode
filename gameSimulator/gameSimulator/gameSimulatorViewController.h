//
//  gameSimulatorViewController.h
//  gameSimulator
//
//  Created by Niklas Nordin on 2013-11-09.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gameEngine.h"

@interface gameSimulatorViewController : UIViewController

@property (strong, nonatomic) gameEngine *engine;

@end
