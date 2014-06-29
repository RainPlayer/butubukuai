//
//  CollectionController.h
//  不吐不快
//
//  Created by WildCat on 13-10-28.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;
@interface CollectionController : UITableViewController
@property NSMutableArray *myArray;
@property User *userInfo;
-(void) passUserInfo:(User *) passUserInfo;
@end
