//
//  settingsDB.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-07-14.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "settingsDB.h"

@implementation settingsDB

- (BOOL)saveToUserDefaults:(NSUserDefaults *)defaults
{
    
    [defaults setObject:self.backgroundColor forKey:@"backgroundColor"];
    [defaults setObject:self.textColor forKey:@"textColor"];
    
    return TRUE;
}

- (void)readFromUserDefaults:(NSUserDefaults *)defaults
{
    if ([defaults objectForKey:@"backgroundColor"])
    {
        self.backgroundColor = [defaults objectForKey:@"backgroundColor"];
    }
    else
    {
        // default background color
        self.backgroundColor = [UIColor blueColor];
    }

    if ([defaults objectForKey:@"textColor"])
    {
        self.textColor = [defaults objectForKey:@"textColor"];
    }
    else
    {
        // default text color
        self.textColor = [UIColor blackColor];
    }
    
}
@end
