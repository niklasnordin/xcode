//
//  twinstabookFirstViewController.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-17.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreDataTableViewController.h"

#import "tif_db.h"
#import "twinstabookAppDelegate.h"
#import "JMPickerView.h"

@interface twinstabookFirstViewController : UIViewController
<
    UITableViewDataSource,
    JMPickerViewDelegate
>

@property (weak, nonatomic) tif_db *database;
@property (strong, nonatomic) JMPickerView *picker;
@property (strong, nonatomic) UIRefreshControl *refreshController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) IBOutlet UIButton *feedButton;
- (IBAction)feedButtonClicked:(id)sender;
- (NSString *)nameForPicker:(NSInteger)index;
@property (strong, nonatomic) CoreDataTableViewController *cdtvc;
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;

@end
