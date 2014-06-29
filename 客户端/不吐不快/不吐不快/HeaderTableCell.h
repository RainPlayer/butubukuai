//
//  HeaderTableCell.h
//  GodTuCaoDemo1
//
//  Created by WildCat on 13-9-20.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGOImageView;
@class User;
@interface HeaderTableCell : UITableViewCell <UIAlertViewDelegate>
@property (nonatomic) IBOutlet EGOImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property UINavigationController *navigationController;
@property User *userInfo;
-(void) setUrlByString:(NSString *) urlStr;
-(void) addUITapGestureRecognizer:(UITapGestureRecognizer *) recognizer;

@end
