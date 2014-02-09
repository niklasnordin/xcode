//
//  displayObject.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-09.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface displayObject : NSObject

@property (strong, nonatomic) NSString *main;
@property (strong, nonatomic) NSString *sub;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) UIImage *image;

- (id)initWithFacebookDictionary:(NSDictionary *)dict;
- (id)initWithTwitterDictionary:(NSDictionary *)dict;
- (id)initWithInstagramDictionary:(NSDictionary *)dict;

@end
