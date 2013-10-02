//
//  RosinRammlerPDF.m
//  RRDistribution
//
//  Created by Niklas Nordin on 2013-09-28.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "RosinRammlerPDF.h"

@implementation RosinRammlerPDF

- (id)init
{
    self = [super init];
    if (self)
    {
        _lambda = 0.0;
        _k = 0.0;
    }
    return self;
}

- (float)sample:(float)x
{
    //float v = 0.5*arc4random()/(float)RAND_MAX;
    //float v = ((float)rand())/RAND_MAX;
    float v = self.lambda*powf(-log(1.0 - x), 1.0/self.k);
    //NSLog(@"v=%f",v);
    return v;
}

@end
