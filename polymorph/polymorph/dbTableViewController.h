//
//  dbTableViewController.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-31.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "database.h"
#import "polymorphViewController.h"

@interface dbTableViewController : UITableViewController
<UITextFieldDelegate, UIAlertViewDelegate>

@property (strong,nonatomic) database *db;
@property (strong, nonatomic) polymorphViewController* parent;

@property (strong, nonatomic) NSMutableArray *functionNames;

@end
