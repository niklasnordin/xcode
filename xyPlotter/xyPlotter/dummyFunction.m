//
//  dummyFunction.m
//  xyPlotter
//
//  Created by Niklas Nordin on 2013-03-02.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "dummyFunction.h"

@implementation dummyFunction


-(CGFloat) xMin
{
    return -3.0;
}

-(CGFloat) xMax
{
    return 3.0;
    
}

-(CGFloat) yMin
{
    return -1.0;
}

-(CGFloat) yMax
{
    return 1.0;
}

-(double) yForX:(double)x
{
    NSLog(@"calling function");
    return sin(x);
}

@end
