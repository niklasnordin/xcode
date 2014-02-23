//
//  AddGroupMembersViewController.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-23.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMPickerView.h"
#import "tif_db.h"

@interface AddGroupMembersViewController : UIViewController
<
    UITableViewDelegate,
    UITableViewDataSource,
    JMPickerViewDelegate
>

@property (weak, nonatomic) tif_db *database;
@property (weak, nonatomic) NSMutableArray *groupMembers;
@property (strong, nonatomic) JMPickerView *optionsPicker;

- (void)updateOptionsForRow:(NSInteger)row;

@end
