//
//  AttentionsController.h
//  不吐不快
//
//  Created by WildCat on 13-11-1.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttentionsController : UITableViewController
@property NSMutableArray *usersArray;
@property NSString *userId;
-(void) passUserId:(NSString *) passUserId;

@end
