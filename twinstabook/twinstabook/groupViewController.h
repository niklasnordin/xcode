//
//  groupViewController.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-28.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tif_db.h"
#import "twinstabookAppDelegate.h"
#import "JMPickerView.h"

@interface groupViewController : UIViewController
<
    UITableViewDelegate,
    UITableViewDataSource,
    UITextFieldDelegate,
    JMPickerViewDelegate
>

@property (weak, nonatomic) twinstabookAppDelegate *appDelegate;
@property (weak, nonatomic) tif_db *database;
@property (weak, nonatomic) NSMutableArray *groupMembers;

@property (strong, nonatomic) NSString *groupName;
@property (weak, nonatomic) IBOutlet UIButton *feedButton;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *membersTableView;
- (IBAction)feedButtonClicked:(id)sender;
- (IBAction)searchButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *searchActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *searchOptionButton;
- (IBAction)searchOptionButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;

@end
