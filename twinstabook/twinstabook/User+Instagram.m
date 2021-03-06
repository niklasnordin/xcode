//
//  User+Instagram.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-03-13.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//
#import "staticConstants.h"
#import "User+Instagram.h"

@implementation User (Instagram)


+ (User *)instagramUserInContext:(NSManagedObjectContext *)context fromDictionary:(NSDictionary *)dict forUserID:(NSString *)auid
{
    User *usr = nil;
    NSString *uid = [dict objectForKey:@"id"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:moUser];
    request.predicate = [NSPredicate predicateWithFormat:@"( uid == %@ ) AND ( belongsToAccountID == %@ )", uid, auid];

    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || [matches count] > 1)
    {
        // handle error
        NSLog(@"error = %@",error);
        NSLog(@"something went wrong when trying to add instagram user %@ to context",[dict objectForKey:@"name"]);
        NSLog(@"matches.count = %ld",matches.count);
    }
    else if (!matches.count)
    {
        usr = [NSEntityDescription insertNewObjectForEntityForName:moUser inManagedObjectContext:context];
        usr.name = [dict objectForKey:@"username"];
        usr.profileImageData = nil;
        usr.profileImageURL = [dict objectForKey:@"profile_picture"];
        usr.uid = uid;
        usr.type = [NSNumber numberWithInteger:kInstagram];
        usr.updated = [NSDate dateWithTimeIntervalSinceNow:0];
        usr.belongsToAccountID = auid;
    }
    else
    {
        usr = [matches lastObject];
    }
    
    return usr;
}

@end
