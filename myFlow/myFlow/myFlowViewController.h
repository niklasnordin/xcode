//
//  myFlowViewController.h
//  myFlow
//
//  Created by Niklas Nordin on 2012-11-17.
//  Copyright (c) 2012 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myFlowView.h"
#import "setupView.h"
#import "database.h"

@interface myFlowViewController : UIViewController

@property (strong, nonatomic) database *db;

@property (weak, nonatomic) IBOutlet myFlowView *flowView;

@end
