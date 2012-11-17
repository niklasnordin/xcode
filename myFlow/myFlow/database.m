//
//  database.m
//  myFlow
//
//  Created by Niklas Nordin on 2012-11-17.
//  Copyright (c) 2012 Niklas Nordin. All rights reserved.
//

#import "database.h"

@implementation database

-(database *)initWithBounds:(CGRect)bounds
{
    if (self = [super init])
    {
        _nx = bounds.size.width;
        _ny = bounds.size.height;
    }
    NSLog(@"initWithBounds, nx=%d, ny=%d",_nx,_ny);
    int size = _nx*_ny;
    _u = malloc(size*sizeof(double));
    _v = malloc(size*sizeof(double));
    _p = malloc(size*sizeof(double));
    _rho = malloc(size*sizeof(double));
    _T = malloc(size*sizeof(double));
    
    return self;
}

-(void)dealloc
{
    free(_u);
    free(_v);
    free(_p);
    free(_rho);
    free(_T);
}
@end
