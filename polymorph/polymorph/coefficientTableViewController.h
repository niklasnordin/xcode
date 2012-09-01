//
//  coefficientTableViewController.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-10.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface coefficientTableViewController : UITableViewController <UITextFieldDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) NSMutableArray *coefficients;

@end
