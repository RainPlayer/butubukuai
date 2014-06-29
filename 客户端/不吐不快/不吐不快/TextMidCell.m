//
//  TextMidCell.m
//  不吐不快
//
//  Created by WildCat on 13-10-9.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import "TextMidCell.h"

@implementation TextMidCell
@synthesize myTextLabel;

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
#pragma mark 设置Cell的边框宽度
- (void)setFrame:(CGRect)frame {
    frame.origin.x += 10;
    frame.size.width -= 2 * 10;
    [super setFrame:frame];
}
@end
