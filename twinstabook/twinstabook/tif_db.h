//
//  tif_db.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-23.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *USEFACEBOOK = @"usefacebook";
static NSString *USETWITTER = @"useTwitter";
static NSString *USEINSTAGRAM = @"useInstagram";

@interface tif_db : NSObject

@property (nonatomic) bool useFacebook;
@property (nonatomic) bool useTwitter;
@property (nonatomic) bool useInstagram;

-(id)init;
-(void)saveDatabase;

@end
