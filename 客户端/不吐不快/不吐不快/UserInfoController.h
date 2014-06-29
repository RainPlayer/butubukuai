//
//  UserInfoController.h
//  不吐不快
//
//  Created by WildCat on 13-10-31.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGOImageView;
@class User;
@interface UserInfoController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSString* filePath;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet EGOImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *guanZhuBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLable;
-(void)passUserInfo:(User *) userInfo;
-(void) setUrlByString:(NSString *) urlStr;

- (IBAction)guanzhuBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *myAlertLabel;

@end
