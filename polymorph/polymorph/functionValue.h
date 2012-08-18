//
//  functionValue.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol functionValue <NSObject>

-(double) value:(NSArray *)coeffs T:(double)T p:(double)p;
-(int) nCoefficients;
-(bool) pressureDependent;
-(NSString *) name;

@end
