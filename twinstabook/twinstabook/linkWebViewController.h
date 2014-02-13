//
//  linkWebViewController.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-13.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface linkWebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) NSString *urlString;


@end
