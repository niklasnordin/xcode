//
//  settingsDB.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-07-14.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "settingsDB.h"
#import "QuartzCore/QuartzCore.h"

#define BACKGROUNDCOLOR @"backgroundColor"
#define TEXTCOLOR @"textColor"
#define MULTIPLIER 1.05
#define DARKER 0.92

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
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    }
    
    if ([defaults objectForKey:@"textColor"])
    {
        NSData *textColorData = [defaults objectForKey:TEXTCOLOR];
        self.textColor = [NSKeyedUnarchiver unarchiveObjectWithData:textColorData];
    }
    else
    {
        // default text color
        self.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    }
    
}

- (UIColor *)darkerBackgroundColor
{
    CGFloat red,green,blue,alpha;
    [self.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
    CGFloat newRed = DARKER*red;    
    CGFloat newGreen = DARKER*green;    
    CGFloat newBlue = DARKER*blue;
    
    _darkerBackgroundColor = [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:alpha];
    
    return _darkerBackgroundColor;
}


- (UIColor *)selectedButtonColor
{
    CGFloat red,green,blue,alpha;
    [self.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
    CGFloat newRed = MULTIPLIER*red;
    if (newRed > 1.0) newRed = 1.0f;
        
    CGFloat newGreen = MULTIPLIER*green;
    if (newGreen > 1.0) newGreen = 1.0f;
        
    CGFloat newBlue = MULTIPLIER*blue;
    if (newBlue > 1.0) newBlue = 1.0f;
        
    _selectedButtonColor = [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:alpha];
    
    return _selectedButtonColor;
}

- (UIColor *)selectedTextColor
{
    CGFloat red,green,blue,alpha;
    [self.textColor getRed:&red green:&green blue:&blue alpha:&alpha];
    CGFloat newRed = MULTIPLIER*red;
    if (newRed > 1.0) newRed = 1.0f;
        
    CGFloat newGreen = MULTIPLIER*green;
    if (newGreen > 1.0) newGreen = 1.0f;
        
    CGFloat newBlue = MULTIPLIER*blue;
    if (newBlue > 1.0) newBlue = 1.0f;
        
    _selectedTextColor = [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:alpha];

    return _selectedTextColor;
   
}

- (void)setNavigationColors:(UIViewController *)view
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.textColor, UITextAttributeTextColor,
                          [UIColor clearColor], UITextAttributeTextShadowColor, nil];
    
    [view.navigationController.navigationBar setTitleTextAttributes:dict];
    
    NSArray *leftItems = view.navigationItem.leftBarButtonItems;
    NSArray *rightItems = view.navigationItem.rightBarButtonItems;
    
    for (UIBarButtonItem *item in leftItems)
    {
        [item setTitleTextAttributes:dict forState:UIControlStateNormal];
    }
    for (UIBarButtonItem *item in rightItems)
    {
        [item setTitleTextAttributes:dict forState:UIControlStateNormal];
    }

    //[view.navigationController.navigationBar.backItem setTi]
}

- (void)setupButton:(UIButton *)button withColor:(UIColor *)color
{
    
    [button setBackgroundColor:color];
    [button setTitleColor:self.textColor forState:UIControlStateNormal];
    [button setTitleColor:self.selectedTextColor forState:UIControlStateHighlighted];
        
    [button.layer setCornerRadius:15.0f];
    [button.layer setMasksToBounds:NO];
    [button.layer setBorderWidth:2.0f];
    [button.layer setBorderColor:[self.selectedButtonColor CGColor]];
        
    [button.layer setShadowColor:[UIColor blackColor].CGColor];
    [button.layer setShadowOpacity:0.8];
    [button.layer setShadowRadius:2.0f];
    [button.layer setShadowOffset:CGSizeMake(2.0f, 2.0f)];

}

@end
