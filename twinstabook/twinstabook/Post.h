//
//  Post.h
//  twinstabook
//
//  Created by Niklas Nordin on 09/03/14.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Post : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) User *postedBy;

@end
