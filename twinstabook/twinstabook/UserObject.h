//
//  UserObject.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-24.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObject : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *uid;
@property (nonatomic) NSInteger type;
@property (strong, nonatomic) NSData *imageData;

- (id)init;

@end
