//
//  Post+Instagram.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-03-13.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//
#import "staticConstants.h"
#import "Post+Instagram.h"
#import "User+Instagram.h"

@implementation Post (Instagram)


+ (Post *)addInstagramPostToContext:(NSManagedObjectContext *)context fromDictionary:(NSDictionary *)dict forUserID:(NSString *)uid
{

    Post *post = nil;
    NSString *postID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:moPost];

    request.predicate = [NSPredicate predicateWithFormat:@"( postID == %@ )  AND ( postedBy.belongsToAccountID == %@ )",postID, uid];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // handle error
    if (!matches || error || [matches count] > 1)
    {
        // do it
        NSLog(@"error = %@",error);
        NSLog(@"something went wrong when trying to add instagram post %@ to context",dict);
        NSLog(@"matches.count = %ld",matches.count);
    }
    else
    {

        if ([matches count]) // should only be one
        {
            post = [matches lastObject];
        }
        else
        {
            post = [NSEntityDescription insertNewObjectForEntityForName:moPost inManagedObjectContext:context];
            //NSLog(@"dict = %@",dict);
            post.postID = postID;
            NSDictionary *caption = [dict objectForKey:@"caption"];
            if (![caption isKindOfClass:[NSNull class]])
            {
                post.message = [caption objectForKey:@"text"];
            }
            NSTimeInterval unix_timestamp = [[dict objectForKey:@"created_time"] doubleValue];
            post.date = [NSDate dateWithTimeIntervalSince1970:unix_timestamp];

            NSDictionary *imagesDict = [dict objectForKey:@"images"];
            NSDictionary *standardImageDict = [imagesDict objectForKey:@"standard_resolution"];
            post.imageURL = [standardImageDict objectForKey:@"url"];
            
            NSDictionary *userDict = [dict objectForKey:@"user"];
            User *user = [User instagramUserInContext:context fromDictionary:userDict forUserID:uid];
            post.postedBy = user;
            
        }
        
        // always update the number of likes/comments...
        NSDictionary *commentsDict = [dict objectForKey:@"comments"];
        NSNumber *comments = [commentsDict objectForKey:@"count"];
        
        NSDictionary *likesDict = [dict objectForKey:@"likes"];
        NSNumber *likes = [likesDict objectForKey:@"count"];
        
        if (comments.intValue != post.comments.intValue)
        {
            post.comments = comments;
        }
        if (likes.intValue != post.likes.intValue)
        {
            post.likes = likes;
        }
    }
    
    return post;
    
}

@end
