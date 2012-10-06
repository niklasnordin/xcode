//
//  iapws97_2.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-06.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iapws97_2 : NSObject

@property (nonatomic) long double *ii;
@property (nonatomic) long double *ji;
@property (nonatomic) long double *ni;

@property (nonatomic) long double tstar;
@property (nonatomic) long double pstar;
@property (nonatomic) long double R;

-(long double)gammaForP:(long double)p andT:(long double)T;
-(long double)dgdpForP:(long double)p andT:(long double)T;
-(long double)d2gdp2ForP:(long double)p andT:(long double)T;
-(long double)dgdtForP:(long double)p andT:(long double)T;
-(long double)d2gdt2ForP:(long double)p andT:(long double)T;
-(long double)d2gdtdpForP:(long double)p andT:(long double)T;

-(double)vForP:(long double)p andT:(long double)T;
-(double)rhoForP:(long double)p andT:(long double)T;
-(double)uForP:(long double)p andT:(long double)T;
-(double)hForP:(long double)p andT:(long double)T;
-(double)sForP:(long double)p andT:(long double)T;
-(double)cpForP:(long double)p andT:(long double)T;
-(double)cvForP:(long double)p andT:(long double)T;
-(double)wForP:(long double)p andT:(long double)T;

@end
