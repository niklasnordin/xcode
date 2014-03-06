//
//  displayObject.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-09.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserObject.h"
#import "tif_db.h"

@interface DisplayObject : NSObject

@property (strong, nonatomic) UserObject *user;

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *subTitle;
@property (strong, nonatomic) NSString *link;
@property (nonatomic) kMediaTypes type;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) UIImage *image;
@property (strong,nonatomic) UIImage *typeImage;

- (id)initWithFacebookDictionary:(NSDictionary *)dict;
- (id)initWithTwitterDictionary:(NSDictionary *)dict;
- (id)initWithInstagramDictionary:(NSDictionary *)dict;

@end
