//
//  diagramViewController.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-25.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "functions.h"
#import "functionValue.h"
#import "diagramView.h"

@interface diagramViewController : UIViewController
<
    UITextFieldDelegate,
    UIActionSheetDelegate,
    MFMailComposeViewControllerDelegate
>

@property (strong,nonatomic) id <functionValue> function;
@property (nonatomic) NSDictionary *dict;
@property (nonatomic) double xMin, xMax;
@property (nonatomic) double pressure;
@property (strong, nonatomic) NSArray *coeffs;
@property (strong, nonatomic) NSString *specie;
@property (strong, nonatomic) NSString *property;

@property (strong, nonatomic) IBOutlet diagramView *dview;
- (IBAction)generateTable:(id)sender;

-(void) setup:(id <functionValue>)f
         dict:(NSDictionary *)dict
          min:(double)xmin
          max:(double)xmax
     pressure:(double)p;

@end
