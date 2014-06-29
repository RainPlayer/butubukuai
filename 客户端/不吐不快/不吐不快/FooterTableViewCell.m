//
//  FooterTableViewCell.m
//  GodTuCaoDemo1
//
//  Created by WildCat on 13-9-27.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import "FooterTableViewCell.h"

@implementation FooterTableViewCell
@synthesize badBtn;
@synthesize goodBtn;
@synthesize commentBtn;
@synthesize praisenumberLabel;
@synthesize badnumberLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
           
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
      
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
