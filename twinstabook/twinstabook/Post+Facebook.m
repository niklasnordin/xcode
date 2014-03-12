 //
//  Post+Facebook.m
//  twinstabook
//
//  Created by Niklas Nordin on 09/03/14.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "Post+Facebook.h"
#import "User.h"
#import "User+Facebook.h"
#import "staticConstants.h"

@implementation Post (Facebook)

+ (Post *)addDummyToContext:(NSManagedObjectContext *)context
{

    Post *post = [NSEntityDescription insertNewObjectForEntityForName:moPost inManagedObjectContext:context];
    User *user = [User dummyUserInContext:context];
    
    post.message = @"its a facebook dummy post";
    
    post.postedBy = user;
    
    return post;

/*
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:moPost];
    request.predicate = [NSPredicate predicateWithFormat:@"url = %@",dummy];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // handle error
    if (!matches || error)
    {
        // do it
        NSLog(@"matches is nil for creating post. error = %@",error);
    }
    else
    {
        if ([matches count])
        {
            post = [matches lastObject];
        }
        else
        {
            post = [NSEntityDescription insertNewObjectForEntityForName:moPost inManagedObjectContext:context];
        }
    }
 */
}

@end
