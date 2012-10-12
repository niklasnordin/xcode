//
//  iapws97.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-12.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "functionValue.h"

@interface iapws97 : NSObject <functionValue>

@property (nonatomic) long double *ni;
@property (nonatomic) long double tstar;
@property (nonatomic) long double pstar;

@property (strong, nonatomic) id<functionValue> iapws1;
@property (strong, nonatomic) id<functionValue> iapws2;
@property (strong, nonatomic) id<functionValue> iapws2b;
@property (strong, nonatomic) id<functionValue> iapws3;
@property (strong, nonatomic) id<functionValue> iapws4;
@property (strong, nonatomic) id<functionValue> iapws5;

-(double)pressureForT:(double)T;
-(double)temperatureForP:(double)p;

@end
