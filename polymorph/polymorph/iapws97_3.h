//
//  iapws97_3.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-11.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "functionValue.h"
#import "iapws97_4.h"

typedef enum {
                r3a, r3b, r3c, r3d, r3e, r3f, r3g,
                r3h, r3i, r3j, r3k, r3l, r3m, r3n,
                r3o, r3p, r3q, r3r, r3s, r3t, r3u,
                r3v, r3w, r3x, r3y, r3z, none3
            } subregion3;

@interface iapws97_3 : NSObject <functionValue>

@property (nonatomic) long double *ii;
@property (nonatomic) long double *ji;
@property (nonatomic) long double *ni;

@property (nonatomic) long double tstar;
@property (nonatomic) long double rhostar;
@property (nonatomic) long double R;

@property (nonatomic) long double *it3ab;
@property (nonatomic) long double *nt3ab;

@property (nonatomic) long double *it3cd;
@property (nonatomic) long double *nt3cd;

@property (nonatomic) long double *ct3ef;

@property (nonatomic) long double *it3gh;
@property (nonatomic) long double *nt3gh;

@property (nonatomic) long double *it3ij;
@property (nonatomic) long double *nt3ij;

@property (nonatomic) long double *it3jk;
@property (nonatomic) long double *nt3jk;

@property (nonatomic) long double *it3mn;
@property (nonatomic) long double *nt3mn;

@property (nonatomic) long double *it3op;
@property (nonatomic) long double *nt3op;

@property (nonatomic) long double *it3qu;
@property (nonatomic) long double *nt3qu;

@property (nonatomic) long double *it3rx;
@property (nonatomic) long double *nt3rx;

@property (nonatomic) long double *it3uv;
@property (nonatomic) long double *nt3uv;

@property (nonatomic) long double *it3wx;
@property (nonatomic) long double *nt3wx;

@property (nonatomic) long double *para;
@property (nonatomic) long double *parb;
@property (nonatomic) long double *parc;
@property (nonatomic) long double *pard;

@property (nonatomic) long double *pare;
@property (nonatomic) long double *parf;
@property (nonatomic) long double *parg;
@property (nonatomic) long double *parh;

@property (nonatomic) long double *pari;
@property (nonatomic) long double *parj;
@property (nonatomic) long double *park;
@property (nonatomic) long double *parl;

@property (nonatomic) long double *parm;
@property (nonatomic) long double *parn;
@property (nonatomic) long double *paro;
@property (nonatomic) long double *parp;

@property (nonatomic) long double *parq;
@property (nonatomic) long double *parr;
@property (nonatomic) long double *pars;
@property (nonatomic) long double *part;

@property (nonatomic) long double *paru;
@property (nonatomic) long double *parv;
@property (nonatomic) long double *parw;
@property (nonatomic) long double *parx;
@property (nonatomic) long double *pary;
@property (nonatomic) long double *parz;

@property (nonatomic) long double *iv3a;
@property (nonatomic) long double *jv3a;
@property (nonatomic) long double *nv3a;

@property (nonatomic) long double *iv3b;
@property (nonatomic) long double *jv3b;
@property (nonatomic) long double *nv3b;

@property (nonatomic) long double *iv3c;
@property (nonatomic) long double *jv3c;
@property (nonatomic) long double *nv3c;

@property (nonatomic) long double *iv3d;
@property (nonatomic) long double *jv3d;
@property (nonatomic) long double *nv3d;

@property (nonatomic) long double *iv3e;
@property (nonatomic) long double *jv3e;
@property (nonatomic) long double *nv3e;

@property (nonatomic) long double *iv3f;
@property (nonatomic) long double *jv3f;
@property (nonatomic) long double *nv3f;

@property (nonatomic) long double *iv3g;
@property (nonatomic) long double *jv3g;
@property (nonatomic) long double *nv3g;

@property (nonatomic) long double *iv3h;
@property (nonatomic) long double *jv3h;
@property (nonatomic) long double *nv3h;

@property (nonatomic) long double *iv3i;
@property (nonatomic) long double *jv3i;
@property (nonatomic) long double *nv3i;

@property (nonatomic) long double *iv3j;
@property (nonatomic) long double *jv3j;
@property (nonatomic) long double *nv3j;

@property (nonatomic) long double *iv3k;
@property (nonatomic) long double *jv3k;
@property (nonatomic) long double *nv3k;

@property (nonatomic) long double *iv3l;
@property (nonatomic) long double *jv3l;
@property (nonatomic) long double *nv3l;

@property (nonatomic) long double *iv3m;
@property (nonatomic) long double *jv3m;
@property (nonatomic) long double *nv3m;

@property (nonatomic) long double *iv3n;
@property (nonatomic) long double *jv3n;
@property (nonatomic) long double *nv3n;

@property (nonatomic) long double *iv3o;
@property (nonatomic) long double *jv3o;
@property (nonatomic) long double *nv3o;

@property (nonatomic) long double *iv3p;
@property (nonatomic) long double *jv3p;
@property (nonatomic) long double *nv3p;

@property (nonatomic) long double *iv3q;
@property (nonatomic) long double *jv3q;
@property (nonatomic) long double *nv3q;

@property (nonatomic) long double *iv3r;
@property (nonatomic) long double *jv3r;
@property (nonatomic) long double *nv3r;

@property (nonatomic) long double *iv3s;
@property (nonatomic) long double *jv3s;
@property (nonatomic) long double *nv3s;

@property (nonatomic) long double *iv3t;
@property (nonatomic) long double *jv3t;
@property (nonatomic) long double *nv3t;

@property (nonatomic) long double *iv3u;
@property (nonatomic) long double *jv3u;
@property (nonatomic) long double *nv3u;

@property (nonatomic) long double *iv3v;
@property (nonatomic) long double *jv3v;
@property (nonatomic) long double *nv3v;

@property (nonatomic) long double *iv3w;
@property (nonatomic) long double *jv3w;
@property (nonatomic) long double *nv3w;

@property (nonatomic) long double *iv3x;
@property (nonatomic) long double *jv3x;
@property (nonatomic) long double *nv3x;

@property (nonatomic) long double *iv3y;
@property (nonatomic) long double *jv3y;
@property (nonatomic) long double *nv3y;

@property (nonatomic) long double *iv3z;
@property (nonatomic) long double *jv3z;
@property (nonatomic) long double *nv3z;

@property (nonatomic) long double tbackstar;
@property (nonatomic) long double pbackstar;

-(double)vForP:(long double)pres andT:(long double)T;
-(double)rhoForP:(long double)p andT:(long double)T;
-(double)uForP:(long double)p andT:(long double)T;
-(double)hForP:(long double)p andT:(long double)T;
-(double)sForP:(long double)p andT:(long double)T;
-(double)cpForP:(long double)p andT:(long double)T;
-(double)cvForP:(long double)p andT:(long double)T;
-(double)wForP:(long double)p andT:(long double)T;
-(double)pForRho:(long double)rho andT:(long double)T;

-(subregion3)identifyRegionForP:(double)pressure andT:(double)T;
-(double)T1splitForPi:(double)pi coefficientsN:(long double *)n andI:(long double *)ic andN:(int)N;
-(double)T2splitForPi:(double)pi coefficientsN:(long double *)n andI:(long double *)ic andN:(int)N;
-(double)T3splitForPi:(double)pi coefficients:(long double *)c;

-(double)vptForP:(long double)p
            andT:(long double)T
             par:(long double *)par
          coeffI:(long double *)ci
          coeffJ:(long double *)cj
          coeffN:(long double *)cn
               N:(int)N;

-(double)vnptForP:(long double)p
            andT:(long double)T
             par:(long double *)par
          coeffI:(long double *)ci
          coeffJ:(long double *)cj
          coeffN:(long double *)cn
               N:(int)N;

//@property (strong, nonatomic) id<functionValue> p23;
@property (strong, nonatomic) iapws97_4 *iapws4;

@end
