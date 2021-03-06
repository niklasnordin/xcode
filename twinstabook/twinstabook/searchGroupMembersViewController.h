//
//  searchGroupMembersViewController.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-23.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tif_db.h"

const static int maxImages = 200;

@interface searchGroupMembersViewController : UITableViewController
<
    UITableViewDelegate,
    UITableViewDataSource,
    UISearchBarDelegate,
    UISearchDisplayDelegate,
    UITextFieldDelegate
>

@property (weak, nonatomic) tif_db *database;
@property (strong, nonatomic) NSString *searchFeed;
@property (strong, nonatomic) NSString *searchOption;
@property (weak, nonatomic) NSMutableArray *groupMembers;
@property (weak, nonatomic) UITableView *membersTableView;

@property (nonatomic) NSInteger minStringLength;

@end
