//
//  AddGroupMembersViewController.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-23.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddGroupMembersViewController : UIViewController
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (weak, nonatomic) NSMutableArray *groupMembers;

@end
