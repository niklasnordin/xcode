//
//  loadDatabaseViewController.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-06.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "database.h"
#import "polymorphViewController.h"

@interface loadDatabaseViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) database *db;
@property (strong, nonatomic) polymorphViewController* parent;
@property (strong, nonatomic) NSMutableArray *functionNames;

@property (strong, nonatomic) IBOutlet UITextField *linkTextField;
@property (strong, nonatomic) IBOutlet UILabel *statusTextField;

- (IBAction)loadButton:(id)sender;

@end
