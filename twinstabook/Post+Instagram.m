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


+ (Post *)addInstagramPostToContext:(NSManagedObjectContext *)context fromDictionary:(NSDictionary *)dict
{
    //NSLog(@"dict = %@",dict);
    Post *post = nil;
    NSDictionary *caption = [dict objectForKey:@"caption"];
    NSString *postID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:moPost];
    request.predicate = [NSPredicate predicateWithFormat:@"postID == %@",postID];
    
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
            
            post.postID = postID;
            post.message = [caption objectForKey:@"text"];
            NSTimeInterval unix_timestamp = [[dict objectForKey:@"created_time"] doubleValue];
            post.date = [NSDate dateWithTimeIntervalSince1970:unix_timestamp];

            NSDictionary *imagesDict = [dict objectForKey:@"images"];
            NSDictionary *standardImageDict = [imagesDict objectForKey:@"standard_resolution"];
            post.imageURL = [standardImageDict objectForKey:@"url"];
            NSDictionary *commentsDict = [dict objectForKey:@"comments"];
            NSNumber *comments = [commentsDict objectForKey:@"count"];
            id cmt = [commentsDict objectForKey:@"count"];
            NSLog(@"cmt class = %@",[cmt class]);
            NSLog(@"comments = %@",comments);
            post.comments = comments;
            NSDictionary *likesDict = [dict objectForKey:@"liks"];
            NSNumber *likes = [likesDict objectForKey:@"counts"];
            post.likes = likes;
            NSLog(@"likes = %@",likes);
            NSDictionary *userDict = [dict objectForKey:@"user"];
            //User *user = [User instagramUserInContext:context fromDictionary:userDict];
            User *user = [User instagramUserInContext:context fromDictionary:userDict];
            post.postedBy = user;
            
        }
    }
    
    return post;
    
}

@end
