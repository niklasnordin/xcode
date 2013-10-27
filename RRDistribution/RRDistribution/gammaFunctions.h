//
//  gammaFunctions.h
//  RRDistribution
//
//  Created by Niklas Nordin on 2013-10-11.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#ifndef RRDistribution_gammaFunctions_h
#define RRDistribution_gammaFunctions_h


double gamma_io(double nu, double x);
double gamma_i(double nu, double x);

double fd
(
    const double k,
    const double d,
    const double g3k
);

double find_Dv
(
    const double k,
    const double percent
);

double smdCalc
(
    double k,
    double lambda
);

// ==========

double Gamma_Function(double x);
long double xGamma_Function(long double x);
double Gamma_Function_Max_Arg( void );
long double xGamma_Function_Max_Arg( void );

long double xGamma(long double x);
long double Duplication_Formula( long double two_x );

// =======

double Ln_Gamma_Function(double x);
long double xLn_Gamma_Function(long double x);

long double xLnGamma_Asymptotic_Expansion( long double x );

// =======


double Factorial(int n);
long double xFactorial(int n);
int Factorial_Max_Arg( void );

// =======

double Entire_Incomplete_Gamma_Function(double x, double nu);
long double xEntire_Incomplete_Gamma_Function(long double x, long double nu);

long double xSmall_x(long double x, long double nu);
long double xMedium_x(long double x, long double nu);
long double xLarge_x(long double x, long double nu);

#endif
