//
//  UserViewController.h
//  GodTuCaoDemo1
//
//  Created by WildCat on 13-10-5.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@class EGOImageView;
@interface UserViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
 NSString* filePath;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *topUserView;
@property (weak, nonatomic) IBOutlet EGOImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;



@property (weak, nonatomic) User *userInfo;
@property (weak, nonatomic)  UINavigationBar *topNavigationBar;
-(void) setUrlByString:(NSString *) urlStr;

@property (weak, nonatomic) IBOutlet UIButton *logOutBtn;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginBarBtnItem;
- (IBAction)logOutBtnClicked:(id)sender;

@end
