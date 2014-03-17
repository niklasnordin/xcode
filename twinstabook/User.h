//
//  User.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-03-17.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Post;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * profileImageData;
@property (nonatomic, retain) NSString * profileImageURL;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSString * belongsToAccountID;
@property (nonatomic, retain) NSSet *posts;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addPostsObject:(Post *)value;
- (void)removePostsObject:(Post *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

@end
