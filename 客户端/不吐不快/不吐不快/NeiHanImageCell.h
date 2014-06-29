//
//  NeiHanImageCell.h
//  不吐不快
//
//  Created by WildCat on 13-10-23.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGOImageView;
@interface NeiHanImageCell : UITableViewCell
@property (nonatomic) IBOutlet EGOImageView *btbkImageView;
@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
-(void) setUrlByString:(NSString *) urlStr;
-(void) setBtbkImageViewFram:(CGRect) imageViewRect;
-(void) setTitleLabelText:(NSString *) title;
@end
