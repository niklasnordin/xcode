//
//  groupTableViewController.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-28.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tif_db.h"
#import "twinstabookAppDelegate.h"

@interface groupTableViewController : UITableViewController
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (weak, nonatomic) twinstabookAppDelegate *appDelegate;
@property (weak, nonatomic) tif_db *database;

@end
