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
@property (weak, nonatomic) NSDictionary *dict;
@property (nonatomic) double xMin, xMax;
@property (nonatomic) double cpv; // constantPropertyValue
@property (strong, nonatomic) NSString *specie;
@property (strong, nonatomic) NSString *property;
@property (nonatomic) BOOL xIsT;

@property (weak, nonatomic) IBOutlet diagramView *dview;
- (IBAction)generateTable:(id)sender;

-(void) setup:(id <functionValue>)f
         dict:(NSDictionary *)dict
          min:(double)xmin
          max:(double)xmax
          cpv:(double)cpv;

@end
