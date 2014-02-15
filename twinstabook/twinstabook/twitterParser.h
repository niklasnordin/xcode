//
//  twitterParser.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-13.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "displayObject.h"

@interface twitterParser : NSObject

+ (displayObject *)parse:(NSDictionary *)dict;

@end
