//
//  EGRCompositionVC.h
//  EGRCalculator
//
//  Created by Niklas Nordin on 2011-12-03.
//  Copyright (c) 2011 nequam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGRCalculator.h"

@interface EGRCompositionVC : UIViewController
@property (strong, nonatomic) EGRCalculator *egrCalc;

@property (strong, nonatomic) IBOutlet UILabel *xCO2Ex;
@property (strong, nonatomic) IBOutlet UILabel *xH2OEx;
@property (strong, nonatomic) IBOutlet UILabel *xO2Ex;
@property (strong, nonatomic) IBOutlet UILabel *xN2Ex;

@property (strong, nonatomic) IBOutlet UILabel *yCO2Ex;
@property (strong, nonatomic) IBOutlet UILabel *yH2OEx;
@property (strong, nonatomic) IBOutlet UILabel *yO2Ex;
@property (strong, nonatomic) IBOutlet UILabel *yN2Ex;

@property (strong, nonatomic) IBOutlet UILabel *xCO2Cyl;
@property (strong, nonatomic) IBOutlet UILabel *xH2OCyl;
@property (strong, nonatomic) IBOutlet UILabel *xO2Cyl;
@property (strong, nonatomic) IBOutlet UILabel *xN2Cyl;

@property (strong, nonatomic) IBOutlet UILabel *yCO2Cyl;
@property (strong, nonatomic) IBOutlet UILabel *yH2OCyl;
@property (strong, nonatomic) IBOutlet UILabel *yO2Cyl;
@property (strong, nonatomic) IBOutlet UILabel *yN2Cyl;
@property (strong, nonatomic) IBOutlet UILabel *lambdaCyl;

@end






