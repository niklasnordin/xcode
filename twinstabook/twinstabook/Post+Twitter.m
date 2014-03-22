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

+ (Post *)addTwitterPostToContext:(NSManagedObjectContext *)context fromDictionary:(NSDictionary *)dict forUserID:(NSString *)uid
{
    Post *post = nil;
    //NSLog(@"postDict = %@",dict);
    NSString *postID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:moPost];
    request.predicate = [NSPredicate predicateWithFormat:@"( postID == %@ ) AND ( postedBy.belongsToAccountID == %@ )",postID, uid];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // handle error
    if (!matches || error || [matches count] > 1)
    {
        // do it
        NSLog(@"error = %@",error);
        NSLog(@"something went wrong when trying to add twitter post %@ to context",dict);
        NSLog(@"matches.count = %ld",matches.count);
    }
    else
    {
        if ([matches count])
        {
            post = [matches lastObject];
        }
        else
        {
            //NSLog(@"dict = %@",dict);
            post = [NSEntityDescription insertNewObjectForEntityForName:moPost inManagedObjectContext:context];
            
            post.postID = postID;
            post.message = [dict objectForKey:@"text"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
            post.date = [dateFormatter dateFromString:[dict objectForKey:@"created_at"]];
            NSDictionary *entities = [dict objectForKey:@"entities"];
            NSArray *mediaArray = [entities objectForKey:@"media"];
            NSDictionary *media = [mediaArray firstObject];
            post.imageURL = nil;
            post.imageData = nil;
            
            if (media)
            {
                //NSLog(@"media = %@",media);
                NSString *mediaURL = [media objectForKey:@"media_url_https"];
                if (mediaURL)
                {
                    post.imageURL = mediaURL;
                }
            }

            // add the user
            NSDictionary *userDict = [dict objectForKey:@"user"];
            User *user = [User twitterUserInContext:context fromDictionary:userDict forUserID:uid];
            post.postedBy = user;

        }
        
        //check if thes have changes, since a setting of the values will force a reload
        NSNumber *nLikes = [dict objectForKey:@"favorite_count"];
        
        if (nLikes.intValue != post.likes.intValue)
        {
            post.likes = nLikes;
        }
        
        NSNumber *nComments = [dict objectForKey:@"retweet_count"];
        if (nComments.intValue != post.comments.intValue)
        {
            post.comments = nComments;
        }
    }

    return post;

}

@end
