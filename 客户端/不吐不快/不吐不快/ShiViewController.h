//
//  ShiViewController.h
//  GodTuCaoDemo1
//
//  Created by WildCat on 13-9-20.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"  
@interface ShiViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isflage;
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
    
}

@property (nonatomic,retain) NSMutableArray *myArray;
- (IBAction)praiseBtnClick:(id)sender;
- (IBAction)badBtnClick:(id)sender;

//重新加载时调用的的方法
- (void)reloadTableViewDataSource;
//完成加载时调用的方法
- (void)doneLoadingTableViewData;


- (IBAction)collectBtnCilck:(id)sender;

@end
