//
//  commentVC.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-18.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentVC : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) NSString *comment;
@property (weak, nonatomic) NSMutableDictionary *dict;

@end
