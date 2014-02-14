//
//  twitterAccountsTableViewController.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-14.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tif_db.h"

@interface twitterAccountsTableViewController : UITableViewController

@property (weak, nonatomic) NSArray *accounts;
@property (weak, nonatomic) NSMutableArray *selected;

@end
