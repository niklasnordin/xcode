//
//  iapws97_1.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-05.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "functionValue.h"

@interface iapws97_1 : NSObject <functionValue>

@property (nonatomic) long double *ik;
@property (nonatomic) long double *jk;
@property (nonatomic) long double *nk;

@property (nonatomic) long double tstar;
@property (nonatomic) long double pstar;
@property (nonatomic) long double R;

@end
