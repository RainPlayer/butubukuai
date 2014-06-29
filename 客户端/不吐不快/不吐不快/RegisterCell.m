//
//  RegisterCell.m
//  不吐不快
//
//  Created by WildCat on 13-10-13.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import "RegisterCell.h"

@implementation RegisterCell
@synthesize leftLabel;
@synthesize myTextFied;

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
