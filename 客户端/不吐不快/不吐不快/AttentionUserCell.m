//
//  AttentionUserCell.m
//  不吐不快
//
//  Created by WildCat on 13-11-1.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import "AttentionUserCell.h"
#import "EgoImageView.h"
@implementation AttentionUserCell
@synthesize headerImageView;
@synthesize nameLabel;
@synthesize gradeLabel;
-(void)setUrlByString:(NSString *)urlStr{
    headerImageView.imageURL= [NSURL URLWithString:urlStr];
}

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
