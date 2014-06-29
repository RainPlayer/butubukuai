//
//  CommentCell.m
//  不吐不快
//
//  Created by WildCat on 13-10-10.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import "CommentCell.h"
#import "EGOImageView.h"
@implementation CommentCell
@synthesize headerImageView;
@synthesize nameLabel;
@synthesize timerLabel;
@synthesize floorLabel;
@synthesize commentLabel;
-(void) setUrlByString:(NSString *) urlStr{

    headerImageView.imageURL=[NSURL URLWithString:urlStr];
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

@end
