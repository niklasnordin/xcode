//
//  iapws97.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-12.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "iapws97_1.h"
#import "iapws97_2.h"
#import "iapws97_2b.h"
#import "iapws97_3.h"
#import "iapws97_4.h"
#import "iapws97_5.h"

typedef enum { reg1, reg2, reg2b, reg3, reg5, none } region;

@interface iapws97 : NSObject

@property (nonatomic) long double *ni;
@property (nonatomic) long double tstar;
@property (nonatomic) long double pstar;

//@property (strong, nonatomic) id<functionValue> p23;
@property (strong, nonatomic) iapws97_1 *iapws1;
@property (strong, nonatomic) iapws97_2 *iapws2;
@property (strong, nonatomic) iapws97_2b *iapws2b;
@property (strong, nonatomic) iapws97_3 *iapws3;
@property (strong, nonatomic) iapws97_4 *iapws4;
@property (strong, nonatomic) iapws97_5 *iapws5;

-(iapws97 *)initWithZero;
-(iapws97 *)initWithArray:(NSArray *)array;

-(double)PsForT:(double)T;
-(double)TsForP:(double)p;
-(region)setRegionForPressure:(double)p andT:(double)T;

-(double)rhoForP:(double)p andT:(long double)T;
-(NSArray *)dependsOnFunctions;
-(void)setFunction:(id)function forKey:(NSString *)key;
-(NSArray *)coefficientNames;

@end
