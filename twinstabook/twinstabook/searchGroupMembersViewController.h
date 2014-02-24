//
//  searchGroupMembersViewController.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-23.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tif_db.h"
#import "displayObject.h"

@interface searchGroupMembersViewController : UIViewController
<
    UITableViewDelegate,
    UITableViewDataSource,
    UISearchBarDelegate
>

@property (strong, nonatomic) NSMutableArray *tableViewObjects;

@property (strong, nonatomic) NSNumber *downloadImage;
@property (strong, nonatomic) NSMutableDictionary *imageCache;

@property (weak, nonatomic) tif_db *database;
@property (strong, nonatomic) NSString *searchFeed;
@property (strong, nonatomic) NSString *searchOption;

@property (nonatomic) NSInteger minStringLength;

@end
