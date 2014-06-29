//
//  AttentionUserCell.h
//  不吐不快
//
//  Created by WildCat on 13-11-1.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGOImageView;
@interface AttentionUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet EGOImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;

-(void) setUrlByString:(NSString *) urlStr;

@end
