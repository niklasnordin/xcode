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

+ (User *)facebookUserInContext:(NSManagedObjectContext *)context forUserObject:(UserObject *)usrObj forAccountID:(NSString *)auid
{
    User *usr = nil;
    NSString *uid = usrObj.uid;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:moUser];
    //request.predicate = [NSPredicate predicateWithFormat:@"uid == %@", uid];

    request.predicate = [NSPredicate predicateWithFormat:@"(uid == '%@') AND (belongsToAccountID == '%@')", uid, auid];

    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || [matches count] > 1)
    {
        // handle error
    }
    else if (!matches.count)
    {
        usr = [NSEntityDescription insertNewObjectForEntityForName:moUser inManagedObjectContext:context];
        usr.name = usrObj.name;
        usr.profileImageData = usrObj.imageData;
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
