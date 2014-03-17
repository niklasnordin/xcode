//
//  Post.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-03-17.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Post : NSManagedObject

@property (nonatomic, retain) NSNumber * comments;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSNumber * likes;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * postID;
@property (nonatomic, retain) NSString * urlToPost;
@property (nonatomic, retain) User *postedBy;

@end
