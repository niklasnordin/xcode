//
//  MenuTableViewController.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-18.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "twinstabookAppDelegate.h"

@interface SWUITableViewCell : UITableViewCell
//@property (nonatomic) IBOutlet UILabel *label;
@end

@interface MenuTableViewController : UITableViewController

//@property (weak, nonatomic) twinstabookAppDelegate *appDelegate;
@property (weak, nonatomic) tif_db *database;

@end
