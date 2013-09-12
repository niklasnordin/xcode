//
//  EGRCompositionVC.m
//  EGRCalculator
//
//  Created by Niklas Nordin on 2011-12-03.
//  Copyright (c) 2011 nequam. All rights reserved.
//

#import "EGRCompositionVC.h"
#import "EGRCalculator.h"

@implementation EGRCompositionVC

@synthesize egrCalc = _egrCalc;
@synthesize xCO2Ex = _xCO2Ex;
@synthesize xH2OEx = _xH2OEx;
@synthesize xO2Ex = _xO2Ex;
@synthesize xN2Ex = _xN2Ex;
@synthesize yCO2Ex = _yCO2Ex;
@synthesize yH2OEx = _yH2OEx;
@synthesize yO2Ex = _yO2Ex;
@synthesize yN2Ex = yYN2Ex;
@synthesize xCO2Cyl = _xCO2Cyl;
@synthesize xH2OCyl = _xH2OCyl;
@synthesize xO2Cyl = _xO2Cyl;
@synthesize xN2Cyl = _xN2Cyl;
@synthesize yCO2Cyl = _yCO2Cyl;
@synthesize yH2OCyl = _yH2OCyl;
@synthesize yO2Cyl = _yO2Cyl;
@synthesize yN2Cyl = _yN2Cyl;
@synthesize lambdaCyl = _lambdaCyl;

- (void) viewDidLoad
{

    self.xCO2Ex.text = self.egrCalc.xCO2Ex;
    self.yCO2Ex.text = self.egrCalc.yCO2Ex;
    self.xH2OEx.text = self.egrCalc.xH2OEx;
    self.yH2OEx.text = self.egrCalc.yH2OEx;
    self.xO2Ex.text = self.egrCalc.xO2Ex;
    self.yO2Ex.text = self.egrCalc.yO2Ex;
    self.xN2Ex.text = self.egrCalc.xN2Ex;
    self.yN2Ex.text = self.egrCalc.yN2Ex;
    
    self.yO2Cyl.text = self.egrCalc.yO2Cyl;
    self.yN2Cyl.text = self.egrCalc.yN2Cyl;
    self.yCO2Cyl.text = self.egrCalc.yCO2Cyl;
    self.yH2OCyl.text = self.egrCalc.yH2OCyl;
    
    self.xCO2Cyl.text = self.egrCalc.xCO2Cyl;
    self.xH2OCyl.text = self.egrCalc.xH2OCyl;
    self.xO2Cyl.text = self.egrCalc.xO2Cyl;
    self.xN2Cyl.text = self.egrCalc.xN2Cyl;
    
    self.lambdaCyl.text = self.egrCalc.lambdaCyl;
    
}

- (void)viewDidUnload {
    [self setXCO2Ex:nil];
    [self setXH2OEx:nil];
    [self setXO2Ex:nil];
    [self setXN2Ex:nil];
    [self setYCO2Ex:nil];
    [self setYH2OEx:nil];
    [self setYO2Ex:nil];
    [self setYN2Ex:nil];
    [self setXCO2Cyl:nil];
    [self setXH2OCyl:nil];
    [self setXO2Cyl:nil];
    [self setXN2Cyl:nil];
    [self setYCO2Cyl:nil];
    [self setYH2OCyl:nil];
    [self setYO2Cyl:nil];
    [self setYN2Cyl:nil];
    [self setLambdaCyl:nil];
    [super viewDidUnload];
}
@end
