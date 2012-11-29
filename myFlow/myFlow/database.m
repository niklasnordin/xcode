//
//  database.m
//  myFlow
//
//  Created by Niklas Nordin on 2012-11-17.
//  Copyright (c) 2012 Niklas Nordin. All rights reserved.
//

#import "database.h"
#include <Accelerate/Accelerate.h>

@implementation database

-(database *)initWithBounds:(CGRect)bounds
{
    _length = 1.0;
    _mu = 1.0e-3;
    
    if (self = [super init])
    {
        _nx = bounds.size.width;
        _ny = bounds.size.height;
        //_nx = 100;
        //_ny = 100;
    }
    _dx = _length/_nx;
    
    NSLog(@"initWithBounds, nx=%d, ny=%d",_nx,_ny);

    _u   = malloc(_nx*sizeof(double));
    _v   = malloc(_nx*sizeof(double));
    _p   = malloc(_nx*sizeof(double));
    _rho = malloc(_nx*sizeof(double));
    _T   = malloc(_nx*sizeof(double));
    
    for (int i=0; i<_nx; i++)
    {
        _u[i]   = malloc(_ny*sizeof(double));
        _v[i]   = malloc(_ny*sizeof(double));
        _p[i]   = malloc(_ny*sizeof(double));
        _rho[i] = malloc(_ny*sizeof(double));
        _T[i]   = malloc(_ny*sizeof(double));

        for (int j=0; j<_ny; j++) {
            //NSLog(@"%d, %d, %g",i,j,_u[i][j]);
        }
    }
    return self;
}

-(double)laplacian:(double **)phi forI:(int)i andJ:(int)j
{
    return (phi[i+1][j] + phi[i][j+1] - 4.0*phi[i][j] + phi[i-1][j] + phi[i][j-1])/(_dx*_dx);
}

-(void)updateBoundaryConditions
{

    for (int i=0; i<_nx; i++)
    {
        // bottom boundary
        _T[i][0] = 500.0;
        
        // top boundary
        _T[i][_ny-1] = 300.0;
    }
    
    for (int j=0; j<_ny; j++)
    {
        // left boundary
        _T[0][j] = 300.0;
        
        // right boundary
        _T[_nx-1][j] = 300.0;
    }
}

- (void)initializeFields
{
    for (int i=1; i<_nx-1; i++)
    {
        for (int j=1; j<_ny-1; j++)
        {
            double T0 = 300.0;
            _T[i][j] = T0;
        }
    }
}

-(void)solve
{
    [self initializeFields];
    [self updateBoundaryConditions];
    
    __CLPK_integer n = 3;
    __CLPK_integer info;
    
    float A[9] = {
        2.0f, -3.0f, -2.0f,  // The first column of A
        1.0f, -1.0f,  1.0f,  // the second column of A
        -1.0f,  2.0f,  2.0f   // the third column of A
    };
    
    __CLPK_integer ipiv[3];
    
    sgetrf_(&n, &n, A, &n, ipiv, &info);
    
    if (info != 0) {
        printf("sgetrf failed with error code %d\n", (int)info);
    }
    
    float b[3] = { 8.0f, -11.0f, -3.0f };
    
    char transpose = 'N';
    __CLPK_integer nrhs = 1;
    
    sgetrs_(&transpose, &n, &nrhs, A, &n, ipiv, b, &n, &info);
    
    if (info != 0) {
        printf("sgetrs failed with error code %d\n", (int)info);
    }
    
    printf("x = [ %f  %f  %f ]\n", b[0], b[1], b[2]);
    
    double res0 = 0.0;
    for (int i=1; i<_nx-1; i++)
    {
        for (int j=1; j<_ny-1; j++)
        {
            // check if this is not a drawn boundary pixel
            double Aii = 0.0;
            double rhs = 0.0;
            Aii = -4.0*_mu;
            rhs = -_mu*(_T[i+1][j] + _T[i-1][j] + _T[i][j+1] + _T[i][j-1]);
            res0 += fabs(Aii*_T[i][j] - rhs);
        }
    }
    NSLog(@"res0 = %g",res0);
    
    double residual = res0;
    int iteration = 0;
    while (residual > 1.0e-3 && iteration < 20000)
    {
        iteration++;
        [self updateBoundaryConditions];
        // construct matrix
         
        residual = 0.0;
        for (int i=1; i<_nx-1; i++)
        {
            for (int j=1; j<_ny-1; j++)
            {
                // check if this is not a drawn boundary pixel
                double Aii = 0.0;
                double rhs = 0.0;
                Aii = 4.0*_mu;
            
                rhs = _mu*(_T[i+1][j] + _T[i-1][j] + _T[i][j+1] + _T[i][j-1]);
            
                residual += fabs(Aii*_T[i][j] - rhs);
                double Tnew = rhs/Aii;
                //_T[i][j] += 0.9*(Tnew - _T[i][j]);
                _T[i][j] = Tnew;
            }
        }
        residual /= res0;
        NSLog(@"%d. residual = %g",iteration,residual);
    }
    
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
