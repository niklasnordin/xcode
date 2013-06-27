//
//  schemeTableViewController.h
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 6/25/13.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface schemeTableViewController : UITableViewController
<
    UIActionSheetDelegate,
    UITextFieldDelegate
>

@property (weak,nonatomic) NSMutableArray *schemeNames;
@property (weak,nonatomic) UIPickerView *schemePicker;
@property (weak, nonatomic) NSMutableDictionary *schemesDictionary;

- (void)addSchemeButton:(id)sender;
- (void)addSchemeDictionaryWithName:(NSString *)name;
- (void)deleteSchemeDictionaryWithName:(NSString *)name;

@end
