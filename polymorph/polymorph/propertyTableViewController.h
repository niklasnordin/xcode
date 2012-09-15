//
//  propertyTableViewController.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-01.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "database.h"
#import "polymorphViewController.h"

@interface propertyTableViewController : UITableViewController
<UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) database *db;
@property (nonatomic, weak) NSString *specie;
@property (nonatomic, weak) NSMutableArray *functionNames;

@property (weak, nonatomic) polymorphViewController* parent;

@end
