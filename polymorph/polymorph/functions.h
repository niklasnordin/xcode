//
//  functions.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "function_0001.h"
#import "function_0002.h"
#import "nsrds_0.h"
#import "nsrds_1.h"
#import "nsrds_2.h"
#import "nsrds_3.h"
#import "nsrds_4.h"
#import "nsrds_5.h"
#import "nsrds_6.h"

#import "janaf_cp.h"
#import "janaf_h.h"
#import "janaf_s.h"

#import "idealGasLaw.h"
#import "pengRobinson.h"
#import "pengRobinsonLiquid.h"
#import "pengRobinsonVapour.h"
#include "soaveRedlichKwong.h"
#include "pengRobinsonStryjekVera.h"

#import "ancillary_1.h"
#import "ancillary_2.h"
#import "ancillary_3.h"
#import "ancillary_4.h"

#import "FJ_Rho.h"
#import "FJ_Cv.h"
#import "FJ_Cp.h"
#import "FJ_SoundSpeed.h"

#import "boilingTemperature.h"
#import "sutherland.h"
#import "antoine.h"

#import "iapws97_1.h"
#import "iapws97_2.h"
#import "iapws97_2b.h"
#import "iapws97_3.h"
#import "iapws97_4.h"
#import "iapws97_5.h"
#import "iapws97.h"
#import "iapws97_rho.h"
#import "iapws97_u.h"
#import "iapws97_h.h"
#import "iapws97_s.h"
#import "iapws97_cp.h"
#import "iapws97_cv.h"
#import "iapws97_w.h"

@interface functions : NSObject

-(id) select:(NSString *)name withArray:(NSArray *)array;
-(id) select:(NSString *)name;

@end
