//
//  settingsDB.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-07-14.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "settingsDB.h"

#define BACKGROUNDCOLOR @"backgroundColor"
#define TEXTCOLOR @"textColor"

@implementation settingsDB

- (BOOL)saveToUserDefaults:(NSUserDefaults *)defaults
{

    NSData *backgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:self.backgroundColor];
    [defaults setObject:backgroundColorData forKey:BACKGROUNDCOLOR];
    NSData *textColorData = [NSKeyedArchiver archivedDataWithRootObject:self.textColor];
    
    [defaults setObject:textColorData forKey:TEXTCOLOR];
    //[defaults synchronize];
    return TRUE;
}

- (void)readFromUserDefaults:(NSUserDefaults *)defaults
{
    NSLog(@"readFromUserDefaults");
    NSLog(@"defaults = %@",[defaults dictionaryRepresentation]);
    if ([defaults objectForKey:@"backgroundColor"])
    {
        NSData *backgroundColorData = [defaults objectForKey:BACKGROUNDCOLOR];
        self.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:backgroundColorData];
    }
    else
    {
        // default background color
        NSLog(@"setting default background color");
        self.backgroundColor = [UIColor blueColor];
    }

    if ([defaults objectForKey:@"textColor"])
    {
        NSData *textColorData = [defaults objectForKey:TEXTCOLOR];
        self.textColor = [NSKeyedUnarchiver unarchiveObjectWithData:textColorData];
    }
    else
    {
        // default text color
        self.textColor = [UIColor blackColor];
    }
    
}
@end
