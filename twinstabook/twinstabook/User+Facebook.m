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

+ (User *)facebookUserInContext:(NSManagedObjectContext *)context withFacebookDictionary:(NSDictionary *)dict forAccountID:(NSString *)auid
{
    User *usr = nil;

    //NSLog(@"userdict = %@",dict);
    
    NSString *uid = [dict objectForKey:@"id"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:moUser];
    request.predicate = [NSPredicate predicateWithFormat:@"(uid == '%@') AND (belongsToAccountID == '%@')", uid, auid];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || [matches count] > 1)
    {
        // handle error
        NSLog(@"error = %@",error);
        NSLog(@"something went wrong when trying to add user %@ to context",[dict objectForKey:@"name"]);
        NSLog(@"matches.count = %ld",matches.count);
    }
    else if (!matches.count)
    {
        usr = [NSEntityDescription insertNewObjectForEntityForName:moUser inManagedObjectContext:context];
        usr.name = [dict objectForKey:@"name"];
        usr.profileImageData = nil;
        NSDictionary *pictureDict = [[dict objectForKey:@"picture"] objectForKey:@"data"];
        usr.profileImageURL = [pictureDict objectForKey:@"url"];
        usr.uid = uid;
        usr.type = [NSNumber numberWithInteger:kFacebook];
        usr.updated = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
        usr.belongsToAccountID = auid;
    }
    else
    {
        usr = [matches lastObject];
    }

    return usr;
}

+ (User *)facebookUserInContext:(NSManagedObjectContext *)context forUserObject:(UserObject *)usrObj forAccountID:(NSString *)auid
{
    User *usr = nil;
    NSString *uid = usrObj.uid;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:moUser];
    request.predicate = [NSPredicate predicateWithFormat:@"(uid == '%@') AND (belongsToAccountID == '%@')", uid, auid];

    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || [matches count] > 1)
    {
        // handle error
        NSLog(@"something went wrong when trying to add user to context");
    }
    else if (!matches.count)
    {
        usr = [NSEntityDescription insertNewObjectForEntityForName:moUser inManagedObjectContext:context];
        usr.name = usrObj.name;
        usr.profileImageData = nil; //usrObj.imageData;
        usr.profileImageURL = usrObj.profileImageURL;
        usr.uid = usrObj.uid;
        usr.type = [NSNumber numberWithInteger:kFacebook];
        usr.updated = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
        usr.belongsToAccountID = auid;
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
