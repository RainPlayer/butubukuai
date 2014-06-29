//
//  HeaderTableCell.m
//  GodTuCaoDemo1
//
//  Created by WildCat on 13-9-20.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import "HeaderTableCell.h"
#import "EgoImageView.h"
#import "User.h"
#import "UserViewController.h"
@implementation HeaderTableCell
@synthesize headerImage;
@synthesize nameLabel;
@synthesize timerLabel;
@synthesize commentBtn;
@synthesize userInfo;
@synthesize navigationController;
-(void)setUrlByString:(NSString *)urlStr{
    headerImage.imageURL= [NSURL URLWithString:urlStr];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
//        headerImage=[[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"header.jpeg"]];
//        headerImage.frame=CGRectMake(14.0f, 6.0f, 28.f, 28.f);
//        [self.contentView addSubview:headerImage];
//        
      
	}
     
    return self;
}
-(void)addUITapGestureRecognizer:(UITapGestureRecognizer *)recognizer{
    headerImage.userInteractionEnabled=YES;
    
    [headerImage addGestureRecognizer:recognizer]; //添加单击
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
