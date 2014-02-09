//
//  twinstabookFirstViewController.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-17.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tif_db.h"
#import "twinstabookAppDelegate.h"
#import "JMPickerView.h"
#import <FacebookSDK/FacebookSDK.h>

@interface twinstabookFirstViewController : UIViewController
<
    JMPickerViewDelegate
>

@property (weak, nonatomic) twinstabookAppDelegate *appDelegate;
@property (weak, nonatomic) tif_db *database;
@property (strong, nonatomic) JMPickerView *picker;

@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)updateButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *feedButton;
- (IBAction)feedButtonClicked:(id)sender;
- (NSString *)nameForPicker:(NSInteger)index;

@end
