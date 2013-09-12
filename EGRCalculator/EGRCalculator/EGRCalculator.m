//
//  EGRCalculator.m
//  EGRCalculator
//
//  Created by Niklas Nordin on 2011-12-03.
//  Copyright (c) 2011 nequam. All rights reserved.
//

#import "EGRCalculator.h"

#define wC 12.0108
#define wN 14.0067
#define wO 15.99943;
#define wH 1.0097

@interface EGRCalculator()
@property (nonatomic) BOOL calculatedValues;

@property (nonatomic) double xCO2Exl;
@property (nonatomic) double yCO2Exl;
@property (nonatomic) double xH2OExl;
@property (nonatomic) double yH2OExl;
@property (nonatomic) double xO2Exl;
@property (nonatomic) double yO2Exl;
@property (nonatomic) double xN2Exl;
@property (nonatomic) double yN2Exl;

@property (nonatomic) double xCO2Cyll;
@property (nonatomic) double yCO2Cyll;
@property (nonatomic) double xH2OCyll;
@property (nonatomic) double yH2OCyll;
@property (nonatomic) double xO2Cyll;
@property (nonatomic) double yO2Cyll;
@property (nonatomic) double xN2Cyll;
@property (nonatomic) double yN2Cyll;

@property (nonatomic) double lambdaCyll;

@end

@implementation EGRCalculator

@synthesize cm = _cm;
@synthesize cn = _cn;
@synthesize cr = _cr;
@synthesize lambda = _lambda;
@synthesize egr = _egr;
@synthesize n2 = _n2;
@synthesize o2 = _o2;

@synthesize calculatedValues = _calculatedValues;
@synthesize xCO2Exl = _xCO2Exl;
@synthesize yCO2Exl = _yCO2Exl;
@synthesize xH2OExl = _xH2OExl;
@synthesize yH2OExl = _yH2OExl;
@synthesize xO2Exl = _xO2Exl;
@synthesize yO2Exl = _yO2Exl;
@synthesize xN2Exl = _xN2Exl;
@synthesize yN2Exl = _yN2Exl;
@synthesize xCO2Cyll = _xCO2Cyll;
@synthesize yCO2Cyll = _yCO2Cyll;
@synthesize xH2OCyll = _xH2OCyll;
@synthesize yH2OCyll = _yH2OCyll;
@synthesize xO2Cyll = _xO2Cyll;
@synthesize yO2Cyll = _yO2Cyll;
@synthesize xN2Cyll = _xN2Cyll;
@synthesize yN2Cyll = _yN2Cyll;
@synthesize lambdaCyll = _lambdaCyll;

- (EGRCalculator *)initWithLambda:(NSString *)lambda 
                              egr:(NSString *)egr 
                               cn:(NSString *)cn 
                               cm:(NSString *)cm 
                               cr:(NSString *)cr 
                           oxygen:(NSString *)oxygen 
                            nitro:(NSString *)nitro
{
    _lambda = [lambda doubleValue];
    if (_lambda < 1.0) _lambda = 1.0;
    _egr = [egr doubleValue];
    if (_egr < 0) _egr = 0.0;
    if (_egr > 100) _egr = 100;
    _cm = [cm doubleValue];
    _cn = [cn doubleValue];
    _cr = [cr doubleValue];
    _o2 = [oxygen doubleValue];
    _n2 = [nitro doubleValue];
    _calculatedValues = NO;
    
    return self;
}

- (void) calcAll
{
    self.calculatedValues = YES;
    // mol. weights of the species 
    double wO2 = 2.0*wO;
    double wN2 = 2.0*wN;
    double wCO2 = wC + 2.0*wO;
    double wH2O = 2.0*wH + wO;
    double NOratio = self.n2/self.o2;
    
    double aa = self.cn + 0.25*self.cm - 0.5*self.cr;
   
    double mCO2 = self.cn*wCO2;
    double mH2O = 0.5*self.cm*wH2O;
    double mN2 = NOratio*self.lambda*aa*wN2;
    double mO2 = (self.lambda - 1.0)*aa*wO2;
    
    // mass of the residuals
    double mr = mCO2 + mH2O + mN2 + mO2;
    
    // calculate the molar mass
    double Winv = mCO2/wCO2 + mH2O/wH2O + mO2/wO2 + mN2/wN2;    
    double W = 1.0/Winv;
    
    // number of moles of the residuals (adding comment to commit to repository)
    //double nr = self.cn + 0.5*self.cm + NOratio*self.lambda*aa + (self.lambda - 1.0)*aa;
    
    self.yCO2Exl = mCO2/mr;
    self.yH2OExl = mH2O/mr;
    self.yO2Exl = mO2/mr;
    self.yN2Exl = mN2/mr;
    
    self.xCO2Exl = mCO2*W/wCO2;
    self.xH2OExl = mH2O*W/wH2O;
    self.xO2Exl = mO2*W/wO2;
    self.xN2Exl = mN2*W/wN2;
    
    double egr = self.egr/100.0;
    
    double mO2amb = self.lambda*aa*wO2;
    double mN2amb = self.lambda*aa*NOratio*wN2;
    double mAir = mO2amb + mN2amb;

    double mEGR = egr*mAir/(1.0 - egr);
    double mO2cyl = mO2amb + mEGR*self.yO2Exl;
    double mN2cyl = mN2amb + mEGR*self.yN2Exl;
    double mCO2cyl = mEGR*self.yCO2Exl;
    double mH2Ocyl = mEGR*self.yH2OExl;
    
    double mCyl = mO2cyl + mN2cyl + mCO2cyl + mH2Ocyl;
    self.yO2Cyll = mO2cyl/mCyl;
    self.yN2Cyll = mN2cyl/mCyl;
    self.yCO2Cyll = mCO2cyl/mCyl;
    self.yH2OCyll = mH2Ocyl/mCyl;

    self.lambdaCyll = mO2cyl/aa/wO2;
    double wCyl = self.yCO2Cyll/wCO2 + self.yH2OCyll/wH2O + self.yO2Cyll/wO2 + self.yN2Cyll/wN2;
    wCyl = 1.0/wCyl;
    
    self.xCO2Cyll = self.yCO2Cyll*(wCyl/wCO2);
    self.xH2OCyll = self.yH2OCyll*(wCyl/wH2O);
    self.xO2Cyll = self.yO2Cyll*(wCyl/wO2);
    self.xN2Cyll = self.yN2Cyll*(wCyl/wN2);
    
}

- (NSString *)xCO2Ex
{
    if (!self.calculatedValues)
    {
        [self calcAll];
    }
    return [NSString stringWithFormat:@"%g", self.xCO2Exl];
}

- (NSString *)yCO2Ex
{
    if (!self.calculatedValues)
    {
        [self calcAll];
    }
    return [NSString stringWithFormat:@"%g", self.yCO2Exl];
}

- (NSString *)xH2OEx
{
    if (!self.calculatedValues)
    {
        [self calcAll];
    }
    return [NSString stringWithFormat:@"%g", self.xH2OExl];
}

- (NSString *)yH2OEx
{
    if (!self.calculatedValues)
    {
        [self calcAll];
    }
    return [NSString stringWithFormat:@"%g", self.yH2OExl];
}

- (NSString *)xO2Ex
{
    if (!self.calculatedValues)
    {
        [self calcAll];
    }
    return [NSString stringWithFormat:@"%g", self.xO2Exl];
}

- (NSString *)yO2Ex
{
    if (!self.calculatedValues)
    {
        [self calcAll];
    }
    return [NSString stringWithFormat:@"%g", self.yO2Exl];
}

- (NSString *)xN2Ex
{
    if (!self.calculatedValues)
    {
        [self calcAll];
    }
    return [NSString stringWithFormat:@"%g", self.xN2Exl];
}

- (NSString *)yN2Ex
{
    if (!self.calculatedValues)
    {
        [self calcAll];
    }
    return [NSString stringWithFormat:@"%g", self.yN2Exl];
}

- (NSString *)xCO2Cyl
{
    if (!self.calculatedValues)
    {
        [self calcAll];
    }
    return [NSString stringWithFormat:@"%g", self.xCO2Cyll];
}

- (NSString *)yCO2Cyl
{
    if (!self.calculatedValues)
    {
        [self calcAll];
    }
    return [NSString stringWithFormat:@"%g", self.yCO2Cyll];
}

- (NSString *)xH2OCyl
{
    if (!self.calculatedValues)
    {
        [self calcAll];
    }
    return [NSString stringWithFormat:@"%g", self.xH2OCyll];
}

- (NSString *)yH2OCyl
{
    if (!self.calculatedValues)
    {
        [self calcAll];
    }
    return [NSString stringWithFormat:@"%g", self.yH2OCyll];
}

- (NSString *)xO2Cyl
{
    if (!self.calculatedValues)
    {
        [self calcAll];
    }
    return [NSString stringWithFormat:@"%g", self.xO2Cyll];
}

- (NSString *)yO2Cyl
{
    if (!self.calculatedValues)
    {
        [self calcAll];
    }
    return [NSString stringWithFormat:@"%g", self.yO2Cyll];
}

- (NSString *)xN2Cyl
{
    if (!self.calculatedValues)
    {
        [self calcAll];
    }
    return [NSString stringWithFormat:@"%g", self.xN2Cyll];
}

- (NSString *)yN2Cyl
{
    if (!self.calculatedValues)
    {
        [self calcAll];
    }
    return [NSString stringWithFormat:@"%g", self.yN2Cyll];
}

- (NSString *)lambdaCyl
{
    if (!self.calculatedValues)
    {
        [self calcAll];
    }
    return [NSString stringWithFormat:@"%g", self.lambdaCyll];
}

@end
