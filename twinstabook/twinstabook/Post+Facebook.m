 //
//  Post+Facebook.m
//  twinstabook
//
//  Created by Niklas Nordin on 09/03/14.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <Social/Social.h>

#import "Post+Facebook.h"
#import "User.h"
#import "User+Facebook.h"
#import "staticConstants.h"

@implementation Post (Facebook)

+ (Post *)addDummyToContext:(NSManagedObjectContext *)context
{

    Post *post = [NSEntityDescription insertNewObjectForEntityForName:moPost inManagedObjectContext:context];
    User *user = [User dummyUserInContext:context];
    
    post.date = [NSDate dateWithTimeIntervalSinceNow:0];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString *str = [dateFormatter stringFromDate:post.date];
    NSString *msg = [NSString stringWithFormat:@"its a facebook dummy post created at %@",str];
    post.message = msg;
    post.postedBy = user;
    post.likes = [NSNumber numberWithInt:12];
    post.comments = [NSNumber numberWithInt:124];

    return post;

}

+ (Post *)addFacebookPostToContext:(NSManagedObjectContext *)context fromDictionary:(NSDictionary *)dict forUserObject:(UserObject *)usr forAccountID:(NSString *)auid
{
    Post *post = nil;
    NSString *status_type = [dict objectForKey:@"status_type"];
    
    //NSString *type = [dict objectForKey:@"type"];
    //NSLog(@"type = %@",type);
    
    if ([status_type isEqualToString:@"mobile_status_update"])
    {
        //NSLog(@"dict = %@",dict);
        post = [Post addFacebookMobileStatusUpdateToContext:context fromDictionary:dict forUserObject:usr forAccountID:auid];
    }
    
    return post;
}

+ (Post *)addFacebookMobileStatusUpdateToContext:(NSManagedObjectContext *)context fromDictionary:(NSDictionary *)dict forUserObject:(UserObject *)usr forAccountID:(NSString *)auid
{
    Post *post = nil;
    if (!context)
    {
        return post;
    }
    
    //NSLog(@"postDict = %@",dict);
    
    NSString *postID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:moPost];
    request.predicate = [NSPredicate predicateWithFormat:@"(postID == %@) AND (postedBy.belongsToAccountID == %@)",postID, auid];
    
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
            //NSLog(@"dict = %@",dict);
            post = [NSEntityDescription insertNewObjectForEntityForName:moPost inManagedObjectContext:context];
            
            post.postID = postID;
            post.message = [dict objectForKey:@"message"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            //[dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"]; // twitter
            //[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];

            NSString *created_at = [dict objectForKey:@"created_time"];
            //NSLog(@"created at = %@",created_at);
            post.date = [dateFormatter dateFromString:created_at];
            //NSLog(@"date = %@",post.date);

            post.imageURL = [dict objectForKey:@"picture"];
            post.imageData = nil;
            
            // add the user
            //NSDictionary *userDict = [dict objectForKey:@"user"];
            User *user = [User facebookUserInContext:context forUserObject:usr forAccountID:auid];
            post.postedBy = user;
            
        }
        /*
        __weak Post *blockPost = post;
        
        [Post readLikesForFacebookPost:dict withCompletionHandler:^(NSInteger likes) {
            //dispatch_async(dispatch_get_main_queue(), ^ {
            blockPost.likes = [NSNumber numberWithInteger:likes];
            //});
        }];
        
        [Post readCommentsForFacebookPost:dict withCompletionHandler:^(NSInteger comments) {
            //dispatch_async(dispatch_get_main_queue(), ^ {
                blockPost.comments = [NSNumber numberWithInteger:comments];
            //});
        }];
         */
    }
    
    return post;

}

+ (void)readLikesForFacebookPost:(NSString *)postID withCompletionHandler:(void (^)(NSInteger nLikes))completion
{

    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appID = infoDict[@"FacebookAppID"];
    
    NSArray * permissions = [NSArray arrayWithObjects:@"read_stream",
                             @"read_friendlists",
                             @"user_photos",
                             nil];
    
    NSDictionary *options = @{ ACFacebookPermissionsKey : permissions,
                               ACFacebookAudienceKey : ACFacebookAudienceFriends,
                               ACFacebookAppIdKey : appID };
    
    
     ACAccountStore *account = [[ACAccountStore alloc] init];
     ACAccountType *fbType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];

    [account requestAccessToAccountsWithType:fbType options:options completion:^(BOOL granted, NSError *error)
     {
         NSArray *accounts = [account accountsWithAccountType:fbType];
         // there is only one facebook account
         ACAccount *fbAccount = [accounts lastObject];
         
         NSString *apiString = [NSString stringWithFormat:@"%@/%@/likes",kFacebookGraphRoot,postID];
         NSURL *request = [NSURL URLWithString:apiString];
         NSDictionary *param = @{ @"summary" : @"1" };

         SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:request parameters:param];
         postRequest.account = fbAccount;

         [postRequest performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error)
          {
              if (!error)
              {
                  NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                  NSDictionary *summary = [result objectForKey:@"summary"];
                  NSInteger nCount = [[summary objectForKey:@"total_count"] integerValue];
                  
                  completion(nCount);
              }
          }];

     }];
    
}

+ (void)readCommentsForFacebookPostID:(NSString *)postID withCompletionHandler:(void (^)(NSInteger nComments))completion
{
    
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appID = infoDict[@"FacebookAppID"];
    
    NSArray * permissions = [NSArray arrayWithObjects:@"read_stream",
                             @"read_friendlists",
                             @"user_photos",
                             nil];
    
    NSDictionary *options = @{ ACFacebookPermissionsKey : permissions,
                               ACFacebookAudienceKey : ACFacebookAudienceFriends,
                               ACFacebookAppIdKey : appID };
    
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *fbType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    [account requestAccessToAccountsWithType:fbType options:options completion:^(BOOL granted, NSError *error)
     {
         NSArray *accounts = [account accountsWithAccountType:fbType];
         // there is only one facebook account
         ACAccount *fbAccount = [accounts lastObject];
         
         NSString *apiString = [NSString stringWithFormat:@"%@/%@/comments",kFacebookGraphRoot,postID];
         
         NSURL *request = [NSURL URLWithString:apiString];
         NSDictionary *param = @{ @"summary" : @"1" };
         
         SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:request parameters:param];
         postRequest.account = fbAccount;
         
         [postRequest performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error)
          {
              NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
              NSDictionary *summary = [result objectForKey:@"summary"];
              NSInteger nCount = [[summary objectForKey:@"total_count"] integerValue];
              
              completion(nCount);
          }];
         
     }];
    
}

@end
