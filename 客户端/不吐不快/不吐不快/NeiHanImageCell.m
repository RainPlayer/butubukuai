//
//  NeiHanImageCell.m
//  不吐不快
//
//  Created by WildCat on 13-10-23.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import "NeiHanImageCell.h"
#import "EgoImageView.h"
#define LITTLEFONTCOLOR [UIColor grayColor]
@implementation NeiHanImageCell
@synthesize titleLabel;
@synthesize btbkImageView;
-(void)setUrlByString:(NSString *)urlStr{
    btbkImageView.imageURL = [NSURL URLWithString:urlStr];
}
-(void) setBtbkImageViewFram:(CGRect) imageViewRect{

    [self.btbkImageView setFrame:imageViewRect];

}
-(void) setTitleLabelText:(NSString *) title{
    titleLabel.text=title;

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        btbkImageView=[[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"cc.gif"]];
        btbkImageView.frame=CGRectMake(10.0f, 32.0f, 280.f, 150.f);
        [self.contentView addSubview:btbkImageView];
       
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10.0f, 2.0f, 275.f, 32.f)];
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        titleLabel.numberOfLines = 0;
        titleLabel.font=[UIFont systemFontOfSize:16.f];
        [self.contentView addSubview:titleLabel];
        //titleLabel.text=@"导师工读生反感";
        
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
