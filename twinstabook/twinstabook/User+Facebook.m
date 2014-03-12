//
//  User+Facebook.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-03-11.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "User+Facebook.h"
#import "staticConstants.h"

@implementation User (Facebook)

+ (User *)facebookUserInContext:(NSManagedObjectContext *)context fromPost:(Post *)post
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

+ (User *)dummyUserInContext:(NSManagedObjectContext *)context
{
    User *usr = nil;
    NSString *uid = @"-1";
    
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
        usr.uid = uid;
        usr.name = @"dummy User";
        usr.type = kFacebook;
    }
    else
    {
        usr = [matches lastObject];
    }
    
    return usr;

}

@end
