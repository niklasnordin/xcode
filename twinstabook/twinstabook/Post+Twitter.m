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

+ (Post *)addTwitterPostToContext:(NSManagedObjectContext *)context fromDictionary:(NSDictionary *)dict
{
    Post *post = nil;
    NSLog(@"postDict = %@",dict);
    NSString *postID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:moPost];
    request.predicate = [NSPredicate predicateWithFormat:@"postID = %@",postID];
    
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
            post.message = [dict objectForKey:@"text"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            //[dateFormatter setDateStyle:NSDateFormatterFullStyle];
            //[dateFormatter setTimeStyle:NSDateFormatterFullStyle];
            [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
            post.date = [dateFormatter dateFromString:[dict objectForKey:@"created_at"]];
            NSDictionary *media = [dict objectForKey:@"media"];
            if (media)
            {
                NSString *mediaURL = [media objectForKey:@"media_url_https"];
                if (mediaURL)
                {
                    post.imageURL = mediaURL;
                }
            }
            // add the user
            NSDictionary *userDict = [dict objectForKey:@"user"];
            User *user = [User twitterUserInContext:context fromDictionary:userDict];
            post.postedBy = user;

        }
    }

    return post;

}

@end
