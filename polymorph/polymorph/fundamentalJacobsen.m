//
//  fundamentalJacobsen.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

/*
 
 // Vapor pressure coefficients
 $a_[1] = -0.0514770863682;
 $a_[2] = -8.27075196981;
 $a_[3] = -5.4924538857;
 $a_[4] = 5.64828891406;
 
 // Saturated Liquid Density
 $b_[1] = 2.22194636037;
 $b_[2] = -0.0469267553094;
 $b_[3] = 10.3035666311;
 $b_[4] = -17.2304684516;
 $b_[5] = 8.23564165285;
 
 // Saturated Vapor Density
 $c_[1] = -8.35647816638;
 $c_[2] = -2.38721859682;
 $c_[3] = -39.6946441837;
 $c_[4] = -9.99133502692;
 
 // Ideal Gas Heat Capacity
 $d_[1] = 6.41129104405;
 $d_[2] = 1.95988750679;
 $d_[3] = 7.60084166080;
 $d_[4] = 3.89583440622;
 $d_[5] = 4.23238091363;
*/

#import "fundamentalJacobsen.h"

#define Rgas 8314.462175

static NSString *name = @"fundamentalJacobsen";

@implementation fundamentalJacobsen

+(NSString *)name
{
    return name;
}

-(fundamentalJacobsen *)initWithZero
{
    self = [super init];
    
    int n = [self nCoefficients];
    
    _A = malloc(n*sizeof(double));
    
    for (int i=0; i<n; i++)
    {
        _A[i] = 0.0;
    }
    _functionPointers = [[NSMutableDictionary alloc] init];

    return self;
}

-(fundamentalJacobsen *)initWithArray:(NSArray *)array
{
    self = [super init];
    
    int n = [self nCoefficients];
    
    _A = malloc(n*sizeof(double));
    
    for (int i=0; i<n; i++)
    {
        NSDictionary *Adict = [array objectAtIndex:i];
        NSString *name = [NSString stringWithFormat:@"A%d", i];
        NSNumber *a = [Adict objectForKey:name];
        _A[i] = [a doubleValue];
    }
    
    _functionPointers = [[NSMutableDictionary alloc] init];
    return self;
}

-(NSString *) name
{
    return [fundamentalJacobsen name];
}

-(double)valueForT:(double)T andP:(double)p
{

    //[self setCoeffs:coeff];
    
    double y = 0.0;
    //double y1 = p/( a[0]*T );
    
    //if (y1) y = y1;
    return y;
}

-(bool)pressureDependent
{
    return YES;
}

-(bool)temperatureDependent
{
    return YES;
}

-(int)nCoefficients
{
    return 96;
}

-(void)setCoeffs:(NSArray *)coeffs
{
    for (int i=0; i<23; i++)
    {
        [_nk addObject:[coeffs objectAtIndex:i]];
        [_ik addObject:[coeffs objectAtIndex:i+23]];
        [_jk addObject:[coeffs objectAtIndex:i+46]];
        [_lk addObject:[coeffs objectAtIndex:i+69]];
    }
    
    _tc   = [[coeffs objectAtIndex:92] doubleValue];
    _pc   = [[coeffs objectAtIndex:93] doubleValue];
    _rhoc = [[coeffs objectAtIndex:94] doubleValue];
    _mw   = [[coeffs objectAtIndex:95] doubleValue];
    
    /*
     $rho = rho($pressure, $temp);
    $d = $rho/$rhoc;
    $t = $Tc/$temp;
    
    $cp = cp($d, $t)*1.0e-3/$Mw;
     */
    
}

-(double)rho:(double)pressure T:(double)T
{
    
    /*
    double t = _tc/T;
    double pv = [self Pv:T];
    
    //    echo "Pv($T) = $pv Pa.<br>\n";
    $r = 0.0;
    
    if ($p > $pv)
    {
        $r = rholSat($T);
        //echo "State is liquid.<br>\n";
    }
    else
    {
        $r = rhovSat($T);
        //echo "State is vapour.<br>\n";
    }
    
    $pq = $p/($R*$T);
    
    $i = 0;
    $N = 2000;
    $err = 1.0;
    $tol = 1.0e-12;
    
    while (($err > $tol) && ($i<$N))
    {
        $delta = $r/$rhoc;
        $A = daResdd($delta, $t)/$rhoc;
        $B = d2aResdd2($delta, $t)/$rhoc;
        $d = ($pq - $A*$r*$r - $r)/($B*$r*$r + 2.0*$A*$r + 1.0);
        $err = abs($d)/$r;
        $r = $r + 0.7*$d;
        $i++;
    }
    
    if ($i > $N-2)
    {
        echo "Warning! Density calculation did not converge. Error is $err.<br>\n";
    }
    return $r;
     */
    return 0.0;
}

-(double)Pv:(double)T
{
/*
 
    {
        global $a_, $Tc, $Pc;
        $p = 1.0 - $T/$Tc;
        if ($p < 0.0)
        {
            $p = 0.0;
        }
        
        $s = $a_[1]*pow($p, 0.5) + $a_[2]*$p + $a_[3]*pow($p, 3.0) + $a_[4]*pow($p, 11.0/2.0);
        
        return $Pc*exp($Tc*$s/$T);
    }
 */
    return 0.0;

}
// d = rho/rhoc (kmol/m^3)
// t = Tc/T
-(double)daResdd:(double)d t:(double)t
{
    double sum = 0.0;
    for (int i=0; i<23; i++)
    {
        double gamma = 1.0;
        double nk = [[_nk objectAtIndex:i] doubleValue];
        double ik = [[_ik objectAtIndex:i] doubleValue];
        double jk = [[_jk objectAtIndex:i] doubleValue];
        double lk = [[_lk objectAtIndex:i] doubleValue];
        
        if (abs(lk) < 1.0e-8)
        {
            gamma = 0.0;
        }
        
        double a = nk*pow(t, jk)*exp(-gamma*pow(d, lk));
        double da = -a*gamma*lk*pow(d, lk - 1.0);
        double b = pow(d, ik);
        double db = ik*pow(d, ik - 1.0);
        sum += a*db + b*da;
    }
    
    return sum;
}


- (NSString *)equationText
{
    return @"";
}

- (void)dealloc
{
    free(_A);
}

-(NSArray *)dependsOnFunctions
{
    return @[ @"Pv" ];
}

-(void)setFunction:(id)function forKey:(NSString *)key
{
    [_functionPointers setObject:function forKey:key];
}

@end
