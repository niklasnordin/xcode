//
//  staticConstants.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-03-11.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#ifndef twinstabook_staticConstants_h
#define twinstabook_staticConstants_h

typedef enum : NSInteger
{
    kFacebook = 0,
    kTwitter,
    kInstagram
} kMediaTypes;

// these must be in the same order as the socialMediaNames
static NSString * const FACEBOOK = @"Facebook";
//static const int kFacebook = 0;
static NSString * const TWITTER = @"Twitter";
//static const int kTwitter = 1;
static NSString * const INSTAGRAM = @"Instagram";
//static const int kInstagram = 2;

static NSString * const USEFACEBOOK = @"usefacebook";
static NSString * const USETWITTER = @"useTwitter";
static NSString * const USEINSTAGRAM = @"useInstagram";
static NSString * const SELECTEDMEDIANAME = @"selectedMediaName";
static NSString * const SELECTEDFEEDINDEX = @"selectedFeedIndex";
static NSString * const GROUPS = @"groups";
static NSString * const GROUPMEMBERS = @"groupMembers";
static NSString * const LASTUPDATE = @"lastUpdate";
static NSString * const SELECTEDTWITTERACCOUNT = @"selectedTwitterAccount";
static NSString * const SELECTEDTWITTERACCOUNTINDEX = @"selectedTwitterAccountIndex";

static NSString * const INSTAGRAMACCESSTOKEN = @"instagramAccessToken";
static NSString * const POSTS = @"posts";

static NSString * const kFacebookGraphRoot = @"https://graph.facebook.com";
static NSString * const kTwitterAPIRoot = @"https://api.twitter.com";
static NSString * const kTwitterAPIVersion = @"1.1";

static NSString * const kInstagramBaseURLString = @"https://api.instagram.com/v1/";
static NSString * const kInstagramClientId = @"d2fe9f8c3f6949efa13f439616032bb5";
static NSString * const kInstagramRedirectUrl = @"http://twinstabook.me";

static NSString * const moPost = @"Post";
static NSString * const moUser = @"User";

// for pop up the pickerview
static float const kDistanceFromTop = 20.0f;

// document name
static NSString * const kDocumentName = @"twinstabook";

#endif
