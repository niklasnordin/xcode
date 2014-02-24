//
//  UserObject.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-24.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "UserObject.h"

@implementation UserObject

- (id)init
{
    self = [super init];
    if (self)
    {
        self.type = -1;
        self.name = @"";
        self.uid = @"";
        self.imageData = [[NSData alloc] init];
    }
    
    return self;
}

@end
