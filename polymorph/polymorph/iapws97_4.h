//
//  iapws97_4.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-12.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "functionValue.h"

@interface iapws97_4 : NSObject <functionValue>

@property (nonatomic) double *ni;
@property (nonatomic) double tstar;
@property (nonatomic) double pstar;

-(double)PsForT:(double)T;

@end
