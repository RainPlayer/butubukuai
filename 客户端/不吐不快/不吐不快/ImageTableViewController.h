//
//  ImageTableViewController.h
//  GodTuCaoDemo1
//
//  Created by WildCat on 13-10-5.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderTableCell.h"
#import "FooterTableViewCell.h"
#import "EGORefreshTableHeaderView.h"  
@interface ImageTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isflage;
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
    
}
@property (nonatomic,retain) NSMutableArray   *myArray;
//重新加载时调用的的方法
- (void)reloadTableViewDataSource;
//完成加载时调用的方法
- (void)doneLoadingTableViewData;

- (IBAction)praiseBtnClick:(id)sender;

- (IBAction)badBtnClick:(id)sender;

- (IBAction)collectBtnClick:(id)sender;

@end
