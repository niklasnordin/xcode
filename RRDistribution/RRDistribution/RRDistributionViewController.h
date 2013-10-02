//
//  RRDistributionViewController.h
//  RRDistribution
//
//  Created by Niklas Nordin on 2013-09-28.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pdf.h"
#import "RosinRammlerPDF.h"

@interface RRDistributionViewController : UIViewController

@property (strong, nonatomic) RosinRammlerPDF<pdf> *function;
@property (nonatomic) float lambda;
@property (nonatomic) float k;

@end
