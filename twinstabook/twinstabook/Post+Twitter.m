//
//  Post+Twitter.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-03-13.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "Post+Twitter.h"
#import "User.h"
#import "User+Twitter.h"
#import "staticConstants.h"

@implementation Post (Twitter)

+ (Post *)addPostToContext:(NSManagedObjectContext *)context fromDictionary:(NSDictionary *)dict
{
    Post *post = nil;
    
    NSString *urlString = [dict objectForKey:@"url"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:moPost];
    request.predicate = [NSPredicate predicateWithFormat:@"url = %@",urlString];
    
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
            
            // add the user
            User *user = [User twitterUserInContext:context fromPost:post];
            post.postedBy = user;

        }
    }

    return post;

}

@end
