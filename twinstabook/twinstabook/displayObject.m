//
//  displayObject.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-09.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "displayObject.h"

@implementation displayObject

- (id) init
{
    self = [super init];
    return self;
}

- (id)initWithFacebookDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        
    }
    
    return self;
}


- (id)initWithTwitterDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        _mainTitle = [dict objectForKey:@"text"];
    }
    
    return self;
}


- (id)initWithInstagramDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        
    }
    
    return self;
}

@end
