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
    return -5.0;
}

-(CGFloat) xMax
{
    return 5.0;
    
}

-(CGFloat) validXMin
{
    return -1.0;
}

-(CGFloat) validXMax
{
    return 5.0;
    
}


-(double) yForX:(double)x
{
    //NSLog(@"calling function");
    usleep(5000);
    return sin(x);
}

@end
