//
//  CommentCell.h
//  不吐不快
//
//  Created by WildCat on 13-10-10.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGOImageView;
@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EGOImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property (weak, nonatomic) IBOutlet UILabel *floorLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
-(void) setUrlByString:(NSString *) urlStr;
@end
