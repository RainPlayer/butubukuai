//
//  DuanZiViewController.h
//  不吐不快
//
//  Created by WildCat on 13-10-6.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"  
@interface DuanZiViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isflage;
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
    
}

//重新加载时调用的的方法
- (void)reloadTableViewDataSource;
//完成加载时调用的方法
- (void)doneLoadingTableViewData;
@property (weak, nonatomic)  UINavigationBar *topNavigationBar;
@property (nonatomic,retain) NSMutableArray *myArray;
- (IBAction)praiseBtnClick:(id)sender;

- (IBAction)badBtnClick:(id)sender;
- (IBAction)collecteBtnCilck:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBtnItem;


@end
