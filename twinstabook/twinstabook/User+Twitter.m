//
//  User+Twitter.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-03-13.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "staticConstants.h"
#import "User+Twitter.h"

@implementation User (Twitter)

+ (User *)twitterUserInContext:(NSManagedObjectContext *)context fromPost:(Post *)post
{
    User *usr = nil;
    NSString *uid = post.postedBy.uid;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:moUser];
    request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", uid];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || [matches count] > 1)
    {
        // handle error
    }
    else if (!matches.count)
    {
        usr = [NSEntityDescription insertNewObjectForEntityForName:moUser inManagedObjectContext:context];
        usr.name = post.postedBy.name;
        usr.profileImageData = post.postedBy.profileImageData;
        usr.profileImageURL = post.postedBy.profileImageURL;
        usr.uid = post.postedBy.uid;
        usr.type = post.postedBy.type;
        usr.updated = post.postedBy.updated;
    }
    else
    {
        usr = [matches lastObject];
    }
    
    return usr;
 
}

+ (User *)twitterUserInContext:(NSManagedObjectContext *)context fromUserObject:(UserObject *)obj
{
    User *usr = nil;
    NSString *uid = obj.uid;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:moUser];
    request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", uid];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || [matches count] > 1)
    {
        // handle error
    }
    else if (!matches.count)
    {
        usr = [NSEntityDescription insertNewObjectForEntityForName:moUser inManagedObjectContext:context];
        usr.name = obj.name;
        usr.profileImageData = obj.imageData;
        usr.profileImageURL = obj.profileImageURL;
        usr.uid = uid;
        usr.type = [NSNumber numberWithInteger:kTwitter];
        usr.updated = obj.updated;
    }
    else
    {
        usr = [matches lastObject];
    }
    
    return usr;
}

@end
