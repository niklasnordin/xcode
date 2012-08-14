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

@interface propertyTableViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) database *db;
@property (nonatomic,strong) NSString *specie;
@property (strong, nonatomic) NSMutableArray *functionNames;

@property (strong, nonatomic) polymorphViewController* parent;

@end
