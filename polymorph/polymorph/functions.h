//
//  functions.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "function_0001.h"
#import "function_0002.h"
#import "nsrds_5.h"
#import "nsrds_0.h"
#import "nsrds_1.h"

#import "janaf_cp.h"
#import "janaf_h.h"
#import "janaf_s.h"

#import "idealGasLaw.h"
#import "pengRobinsonLow.h"
#import "pengRobinsonHigh.h"

@interface functions : NSObject

-(id) select:(NSString *) name;

@end
