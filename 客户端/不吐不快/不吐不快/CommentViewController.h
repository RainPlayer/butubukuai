//
//  CommentViewController.h
//  不吐不快
//评论展示页面



//
//  Created by WildCat on 13-10-10.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UITableViewController
@property (nonatomic,retain) NSMutableArray *myArray;

-(void) getPmd5code:(NSString *) pmd5code andFrom:(NSString *)from;




@end
