//
//  iapws97_3.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-11.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "functionValue.h"

@interface iapws97_3 : NSObject <functionValue>

@property (nonatomic) long double *ii;
@property (nonatomic) long double *ji;
@property (nonatomic) long double *ni;

@property (nonatomic) long double tstar;
@property (nonatomic) long double rhostar;
@property (nonatomic) long double R;


@property (strong, nonatomic) id<functionValue> pv;
@property (strong, nonatomic) id<functionValue> rholSat;
@property (strong, nonatomic) id<functionValue> rhovSat;

-(double)vForP:(long double)p andT:(long double)T;
-(double)rhoForP:(long double)p andT:(long double)T;
-(double)uForP:(long double)p andT:(long double)T;
-(double)hForP:(long double)p andT:(long double)T;
-(double)sForP:(long double)p andT:(long double)T;
-(double)cpForP:(long double)p andT:(long double)T;
-(double)cvForP:(long double)p andT:(long double)T;
-(double)wForP:(long double)p andT:(long double)T;
-(double)pForRho:(long double)rho andT:(long double)T;

@end
