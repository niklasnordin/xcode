//
//  MemberTableViewCell.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-28.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "MemberTableViewCell.h"

@implementation MemberTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
