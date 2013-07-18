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
    if ([defaults objectForKey:@"backgroundColor"])
    {
        NSData *backgroundColorData = [defaults objectForKey:BACKGROUNDCOLOR];
        self.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:backgroundColorData];
    }
    else
    {
        // default background color
        NSLog(@"setting default background color");
        self.backgroundColor = [UIColor whiteColor];
    }
    
    {
        CGFloat red,green,blue,alpha;
        [self.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
        CGFloat newRed = 1.1*red;
        if (newRed > 1.0) newRed = 1.0f;
        
        CGFloat newGreen = 1.1*green;
        if (newGreen > 1.0) newGreen = 1.0f;
        
        CGFloat newBlue = 1.1*blue;
        if (newBlue > 1.0) newBlue = 1.0f;
        
        self.selectedButtonColor = [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:alpha];
   
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
    {
        CGFloat red,green,blue,alpha;
        [self.textColor getRed:&red green:&green blue:&blue alpha:&alpha];
        CGFloat newRed = 1.1*red;
        if (newRed > 1.0) newRed = 1.0f;
        
        CGFloat newGreen = 1.1*green;
        if (newGreen > 1.0) newGreen = 1.0f;
        
        CGFloat newBlue = 1.1*blue;
        if (newBlue > 1.0) newBlue = 1.0f;
        
        self.selectedTextColor = [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:alpha];
    }
    
}

@end
