//
//  iapws97.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-12.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "functionValue.h"
#import "iapws97_1.h"
#import "iapws97_2.h"
#import "iapws97_2b.h"
#import "iapws97_3.h"
#import "iapws97_4.h"
#import "iapws97_5.h"

typedef enum { reg1, reg2, reg2b, reg3, reg5, none } region;

@interface iapws97 : NSObject <functionValue>

@property (nonatomic) long double *ni;
@property (nonatomic) long double tstar;
@property (nonatomic) long double pstar;

//@property (strong, nonatomic) id<functionValue> iapws1;
@property (strong, nonatomic) iapws97_1 *iapws1;
@property (strong, nonatomic) iapws97_2 *iapws2;
@property (strong, nonatomic) iapws97_2b *iapws2b;
@property (strong, nonatomic) iapws97_3 *iapws3;
@property (strong, nonatomic) iapws97_4 *iapws4;
@property (strong, nonatomic) iapws97_5 *iapws5;

-(double)PsForT:(double)T;
-(double)TsForP:(double)p;
-(region)setRegionForPressure:(double)p andT:(double)T;

@end
