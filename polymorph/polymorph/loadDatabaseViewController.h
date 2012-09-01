//
//  loadDatabaseViewController.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-06.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "database.h"
#import "polymorphViewController.h"

@interface loadDatabaseViewController : UIViewController
<
    UITextFieldDelegate,
    UIActionSheetDelegate,
    MFMailComposeViewControllerDelegate
>

@property (weak, nonatomic) database *db;
@property (weak, nonatomic) polymorphViewController* parent;
@property (weak, nonatomic) NSMutableArray *functionNames;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) IBOutlet UITextField *linkTextField;
@property (strong, nonatomic) IBOutlet UILabel *statusTextField;

- (IBAction)loadButton:(id)sender;
- (IBAction)mergeButton:(id)sender;
- (IBAction)saveButton:(id)sender;
- (IBAction)exportButton:(id)sender;
- (IBAction)linkFieldEnter:(id)sender;


@end
