//
//  MyProductionViewController.h
//  不吐不快
//
//  Created by WildCat on 13-10-29.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;
@interface MyProductionViewController : UITableViewController
@property (nonatomic,retain) NSMutableArray   *myArray;
@property User *userInfo;
-(void) passUserInfo:(User *) passUserInfo;
@end
