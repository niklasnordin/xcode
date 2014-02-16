//
//  searchTableViewController.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-03.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tif_db.h"

@interface searchTableViewController : UITableViewController
<
    UITableViewDelegate
>

@property (strong, nonatomic) NSNumber *downloadTwitterImage;

@property (weak, nonatomic) tif_db *database;

@property (strong, nonatomic) NSMutableArray *names;
@property (strong, nonatomic) NSMutableDictionary *selectedUsers;

@property (weak, nonatomic) NSString *mediaName;
@property (weak, nonatomic) NSMutableArray *groupMembers;
@property (weak, nonatomic) UITableView *membersTableView;

@end
