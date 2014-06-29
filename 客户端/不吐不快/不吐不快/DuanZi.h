//
//  DuanZi.h
//  不吐不快
//
//  Created by WildCat on 13-10-11.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface DuanZi : NSObject
@property NSNumber *idnumber;
@property NSNumber *userid;
@property NSString *date;
@property NSString *article;
@property NSString *md5code;
@property NSNumber *praisenumber;
@property NSNumber *badnumber;
@property NSString *username;
@property User *userInfo;
@property NSNumber *ifAdded;
@property NSNumber *ifCollected;
@property NSString *type;
@end
