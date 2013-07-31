//
//  settingsDB.h
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-07-14.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface settingsDB : NSObject

@property (strong,nonatomic) UIColor *backgroundColor;
@property (strong,nonatomic) UIColor *darkerBackgroundColor;
@property (strong,nonatomic) UIColor *textColor;

@property (strong,nonatomic) UIColor *selectedButtonColor;
@property (strong,nonatomic) UIColor *selectedTextColor;

- (BOOL)saveToUserDefaults:(NSUserDefaults *)defaults;
- (void)readFromUserDefaults:(NSUserDefaults *)defaults;

@end
