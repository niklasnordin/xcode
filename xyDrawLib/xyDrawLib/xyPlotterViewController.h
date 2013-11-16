//
//  xyPlotterViewController.h
//  xyPlotter
//
//  Created by Niklas Nordin on 2013-03-01.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "xyPlotView.h"
#import "dummyFunction.h"

@interface xyPlotterViewController : UIViewController

@property (strong, nonatomic) dummyFunction *function;
@property (weak, nonatomic) IBOutlet xyPlotView *plotView;

-(void)setup;

@end
