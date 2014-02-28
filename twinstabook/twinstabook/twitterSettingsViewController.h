//
//  twitterSettingsViewController.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-19.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tif_db.h"

@interface twitterSettingsViewController : UIViewController
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (weak, nonatomic) tif_db *db;

@end
