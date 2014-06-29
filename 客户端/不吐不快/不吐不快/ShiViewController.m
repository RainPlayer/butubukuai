//
//  ShiViewController.m
//  GodTuCaoDemo1
//
//  Created by WildCat on 13-9-20.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import "ShiViewController.h"
#import "HeaderTableCell.h"
#import "FooterTableViewCell.h"
#import "TextMidCell.h"
#import "CommentViewController.h"
#import "EditViewController.h"
#import "DuanZi.h"
#import "Reachability.h"
#import "User.h"
#import "UserInfoController.h"
#define BAGCOLOR [UIColor colorWithRed:245.0/255.0 green:223.0/255.0 blue:181.0/255.0 alpha:1.0]
#define TOPBARCOLOR [UIColor colorWithRed:221/255.0f green:170/255.0f blue:59/255.0f alpha:0]
#define TOPCELLCOLOR [UIColor colorWithRed:245.0/255.0 green:243.0/255.0 blue:241.0/255.0 alpha:1.0]

#define FONT_SIZE 16.0f
#define CELL_CONTENT_WIDTH 305.0f
#define CELL_CONTENT_MARGIN 13.0f

@interface ShiViewController ()<EGORefreshTableHeaderDelegate>
@property NSString *urlString;
@property NSMutableArray *itemArray;
@property int page;
@property NSString *serverUrl;
@property NSString *serverRootUrl;
@end

@implementation ShiViewController
@synthesize myArray;
@synthesize urlString;
@synthesize itemArray;
@synthesize page;
@synthesize serverRootUrl;
@synthesize serverUrl;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

     [self.tableView setBackgroundColor:BAGCOLOR];
//    UINavigationBar  * topNavigationBar= self.navigationController.navigationBar;
//    topNavigationBar.tintColor=[UIColor colorWithRed:221/255.0f green:170/255.0f blue:59/255.0f alpha:0];
    //下拉刷新
    if (_refreshHeaderView==nil) {
        //初始化下拉刷新空间
        EGORefreshTableHeaderView *view1=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 10.0f-self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.view.bounds.size.height)];
        view1.delegate = self;
        [self.tableView addSubview:view1];
        _refreshHeaderView = view1;
    }
    
    [_refreshHeaderView refreshLastUpdatedDate];
    //获得服务器地址
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    self.serverRootUrl=[persistentDefaults objectForKey:@"ServerUrl"];
    //初始化url
    self.urlString=[NSString stringWithFormat:@"%@/Poetry/",self.serverRootUrl];
    
    self.page=1;
    itemArray=[NSMutableArray array];
    
    
    //调用解析函数,添加信息
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self parserDuanZi];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
    });
    
    
}

#pragma mark - 解析
#pragma mark 解析内涵段子具体信息
-(void) parserDuanZi
{
    
    if (self.itemArray==nil) {
        self.itemArray=[NSMutableArray array];
    }
    
    //获得json数据
    
    NSString *urlAsString = self.urlString;
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    NSLog(@"poetry:%@",urlAsString);
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"]; //以get方式请求
    NSError *error=nil;
    NSData *condata=[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    
    if ([condata length] >0 && error == nil){
        id jsonObject2 = [NSJSONSerialization
                          JSONObjectWithData:condata
                          options:NSJSONReadingAllowFragments
                          error:&error];
        if (jsonObject2 != nil&& error == nil){
            
            NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject2;
            //遍历数据源获得新闻
            
            
            for (id articleclassname in deserializedDictionary) {
                
                
                if ([articleclassname isEqualToString:@"results"]) {   //获得具体内涵段子信息，接着进行解析
                    id articleElement=[deserializedDictionary objectForKey:articleclassname];
                    DuanZi *duanZi=nil;
                    
                    for (id everyArticel in articleElement) {//遍历每一篇内涵段子
                        duanZi=[[DuanZi alloc] init];
                        for (id detail in everyArticel) {                      //获得每篇文章的内容
                            
                            id ele=[everyArticel objectForKey:detail];
                            if ([detail isEqualToString:@"article"]) {
                                duanZi.article=ele;
                                duanZi.ifAdded=[NSNumber numberWithBool:NO];
                                duanZi.ifCollected=[NSNumber numberWithBool:NO];
                            }else if ([detail isEqualToString:@"userid"]){
                                duanZi.userid=ele;
                                User *userInfo=[self getUserNameById:ele];
                                duanZi.userInfo=userInfo;
                            }else if ([detail isEqualToString:@"date"]){
                                duanZi.date=ele;
                            }else if ([detail isEqualToString:@"md5code"]){
                                duanZi.md5code=ele;
                            }else if ([detail isEqualToString:@"id"]){
                                duanZi.idnumber=ele;
                            }else if ([detail isEqualToString:@"praisenumber"]){
                                duanZi.praisenumber=ele;
                            }else if ([detail isEqualToString:@"badnumber"]){
                                duanZi.badnumber=ele;
                            }
                            
                        }
                        [itemArray insertObject:duanZi atIndex:0];
                        
                    }//end 遍历每一篇内涵段子
                    
                }else if ([articleclassname isEqualToString:@"next"]){// end   获得具体内涵段子信息，接着进行解析
                    NSString *nextUrl=[NSString stringWithFormat:@"%@/Poetry/?page=%d",self.serverRootUrl,++self.page];
                    self.urlString=nextUrl;
                   
                    
                }
                
            }//end for
        }
        
        
    }
    
    self.myArray=itemArray;
    
    
}
-(User *) getUserNameById:(NSNumber *)userid{
    
    NSString *urlAsString = [NSString stringWithFormat:@"%@/user/%@/",self.serverRootUrl,userid];
    User *infoOfUser=[[User alloc] init];
    // NSLog(@"%@",urlAsString);
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"]; //以get方式请求
    NSError *error=nil;
    NSData *condata=[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    
    
    if ([condata length] >0 && error == nil){
        id jsonObject2 = [NSJSONSerialization
                          JSONObjectWithData:condata
                          options:NSJSONReadingAllowFragments
                          error:&error];
        // NSLog(@"%@",jsonObject2);
        
        if (jsonObject2 != nil&& error == nil){
            
            NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject2;
            
            for (id userInfo in deserializedDictionary) {  //获得用户的具体信息
                
                id obj=[deserializedDictionary objectForKey:userInfo];
                if ([userInfo isEqualToString:@"name"]) {
                    infoOfUser.name=obj;
                }else if ([userInfo isEqualToString:@"password"]){
                    infoOfUser.password=obj;
                }else if ([userInfo isEqualToString:@"id"]){
                    infoOfUser.userid=obj;
                }else if ([userInfo isEqualToString:@"grade"]){
                    infoOfUser.grade=obj;
                }else if ([userInfo isEqualToString:@"headerimage"]){
                    infoOfUser.headerimage=obj;
                }
                
            }
        }
        
    }
    
    return infoOfUser;
    
    
}

//ios7的navigationbar默认是透明的，所以当下拉刷新后会出现挡住的情况，下面可以解决
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置挡住的问题
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
        [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    //设置首个section 的header高度
    CGRect frame = self.tableView.tableHeaderView.frame;
    frame.size.height = 10;
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    [self.tableView setTableHeaderView:headerView];

    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    self.myArray=nil;
    self.itemArray=nil;
    self.serverUrl=nil;
    self.urlString=nil;
    self.page=nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=0.f;
    if (indexPath.row%3==1) {
        DuanZi *nowDuanZi=[self.myArray objectAtIndex:indexPath.section];
        NSString *text = nowDuanZi.article;

        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat height = MAX(size.height, 44.0f);
        
        return height + (CELL_CONTENT_MARGIN * 2)-10;
    }else {
        height=35.f;
    }
    return height;
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return myArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 3;
}
#pragma mark 点击用户头像进入个人信息页面
-(void) clickUserHeaderImageSendUserInfo:(UITapGestureRecognizer *)gestureRecognizer{
    
    
    UserInfoController *userInfoController= [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoController"];
    
    CGPoint tapLocation = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *tapIndexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    DuanZi *duanzi=[self.myArray objectAtIndex:tapIndexPath.section];  //获得当前点击的图像
    
    [userInfoController passUserInfo:duanzi.userInfo];
    
    [self.navigationController pushViewController:userInfoController animated:YES];
}
#pragma mark 为Cell添加信息
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"HeaderTableCell";
    static NSString *MidCellIdentifier = @"TextMidCell";
    static NSString *FootCellIdentifier = @"FootCell";
    HeaderTableCell *headerCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    TextMidCell *middleCell= [tableView dequeueReusableCellWithIdentifier:MidCellIdentifier];
    FooterTableViewCell *footCell=[tableView dequeueReusableCellWithIdentifier:FootCellIdentifier];
    DuanZi *nowDuanZi=[self.myArray objectAtIndex:indexPath.section];
    NSString *text = nowDuanZi.article;
    
    if (indexPath.row%3==0) {
        if (headerCell==nil) {
            headerCell=[[HeaderTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        headerCell.timerLabel.text=nowDuanZi.date;
        if ([nowDuanZi.userInfo.headerimage length]>0) {
            [headerCell setUrlByString:[NSString stringWithFormat:@"%@/media/%@",self.serverRootUrl,nowDuanZi.userInfo.headerimage]];
        }
        headerCell.nameLabel.text=[NSString stringWithFormat:@"%@",nowDuanZi.userInfo.name];
        UIView *sectionBagView=[[UIView alloc] initWithFrame:headerCell.bounds] ;
        
        headerCell.backgroundView=sectionBagView;
        headerCell.backgroundView.backgroundColor=TOPCELLCOLOR;
        UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserHeaderImageSendUserInfo:)];
        [headerCell addUITapGestureRecognizer:singleTap]; //添加触摸手势识别
        
        return headerCell;
    }else if(indexPath.row%3==1) {
         UILabel *label = nil; 
        
        if (middleCell==nil) {
            middleCell = [[TextMidCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MidCellIdentifier] ;
            
            label = [[UILabel alloc] initWithFrame:CGRectZero];
            [label setLineBreakMode:UILineBreakModeWordWrap];
            [label setMinimumFontSize:FONT_SIZE];
            [label setNumberOfLines:0];
            [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
            [label setTag:1];
            
            middleCell.myTextLabel=label;
            
        }
        
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        if (! middleCell.myTextLabel)
             middleCell.myTextLabel = (UILabel*)[middleCell viewWithTag:1];
        
        [middleCell.myTextLabel setText:text];
        [middleCell.myTextLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
        
        UIView *sectionBagView=[[UIView alloc] initWithFrame:middleCell.bounds] ;
        middleCell.backgroundView=sectionBagView;
        middleCell.backgroundView.backgroundColor=[UIColor whiteColor];
        //设置选中后的背景颜色
        middleCell.selectedBackgroundView=[[UIView alloc]initWithFrame:middleCell.frame];
        middleCell.selectedBackgroundView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:231.0/255.0 blue:221.0/255.0 alpha:1.0];
        

        return middleCell;

        
    }else if(indexPath.row%3==2){
        if (footCell==nil) {
            footCell=[[FooterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FootCellIdentifier];
        }
                
        UIView *sectionBagView=[[UIView alloc] initWithFrame:footCell.bounds] ;
        footCell.backgroundView=sectionBagView;
        footCell.backgroundView.backgroundColor=[UIColor whiteColor];
        footCell.praisenumberLabel.text=[NSString stringWithFormat:@"%@",nowDuanZi.praisenumber];
        footCell.badnumberLabel.text=[NSString stringWithFormat:@"%@",nowDuanZi.badnumber];
        
        return footCell;
    }
    
    return headerCell;
}


#pragma mark  弹出网络不可用视图
-(void) showNoConnectionView{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"网络不可用，请检查网络!"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}







#pragma mark onClick
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    isflage=!isflage;
    [super.navigationController setNavigationBarHidden:isflage animated:TRUE];
    [super.navigationController setToolbarHidden:isflage animated:TRUE];
}

#pragma mark –
#pragma mark Data Source Loading / Reloading Methods
#pragma mark Data Source 加载/重新加载函数
-(void)doInBackground
{
    //调用解析函数,添加信息
    [self parserDuanZi];
    //后台操作线程执行完后，到主线程更新UI
    [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:YES];
    
}
- (void)doneLoadingTableViewData{
    //NSLog(@"===加载完数据");
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self.tableView reloadData];  //重新加载
}


#pragma mark –
#pragma mark Data Source Loading / Reloading Methods
//重新加载时调用
- (void)reloadTableViewDataSource{
   // NSLog(@"==开始加载数据");
    _reloading = YES;
    //开始刷新后执行后台线程，在此之前可以开启HUD或其他对UI进行阻塞
    [NSThread detachNewThreadSelector:@selector(doInBackground) toTarget:self withObject:nil];
}

#pragma mark –
#pragma mark UIScrollViewDelegate Methods
//滚动控件时的委托方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
#pragma mark –
#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉被调用的委托方法
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}
//放回当前是刷新还是无刷新状态
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading;
}
//返回刷新时间的回调方法
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date];
}

#pragma mark  判断网络是佛连接
-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            // NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    if (!isExistenceNetwork) {
        return NO;
    }
    
    return isExistenceNetwork;
}





#pragma mark 点击收藏
- (IBAction)collectBtnCilck:(id)sender {
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name=[persistentDefaults objectForKey:@"userName"];
    FooterTableViewCell * cell = (FooterTableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    
    DuanZi *clickDuanZi=[self.myArray objectAtIndex:path.section];
    if ([name length]>0) { //已登录
        if ([clickDuanZi.ifCollected boolValue]==NO) {
            NSString *urlAsString = [NSString stringWithFormat:@"%@/addCollection/collector=%@&collectiontype=%@&pid=%@&pmd5code=%@&content=%@&imageurl=%@",self.serverRootUrl,name,@"poetry",clickDuanZi.idnumber,clickDuanZi.md5code,clickDuanZi.article,nil];
            
            NSString *strURL = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
            [req setHTTPMethod:@"GET"];
            [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            NSError *error=nil;
            NSData *condata=[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
            if ([condata length]>0&& error == nil) {
                [self alertMessageClicled:cell andShowStartWidth:270.f andMessage:@"收藏成功"];
                clickDuanZi.ifCollected=[NSNumber numberWithBool:YES];
                [self.myArray replaceObjectAtIndex:path.section withObject:clickDuanZi];  //把是否收藏改为YES
            }
        }
    }else{
        //弹出未登录对话框
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:@"登陆后收藏" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }

    
}
#pragma mark 点击赞
- (IBAction)praiseBtnClick:(id)sender {
    FooterTableViewCell * cell = (FooterTableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSString *md5code=((DuanZi *)[self.myArray objectAtIndex:path.section]).md5code;
    
    DuanZi *clickDuanzi=[self.myArray objectAtIndex:path.section];
    if ([clickDuanzi.ifAdded boolValue]==NO) {
        if ([self isConnectionAvailable]) {
            //向服务器发送好评的MD5code
            NSString *urlAsString = [NSString stringWithFormat:@"%@/addPoetryPraiseNumber/md5code=%@",self.serverRootUrl,md5code];
            
            NSString *strURL = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
            [req setHTTPMethod:@"GET"];
            [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            NSError *error=nil;
            NSData *condata=[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
            if ([condata length]>0&& error == nil) {
                [self addPraiseAndBadNumber:condata andError:error andIndex:path.section];  //调用自定义函数修改数据
            }
            
        }else {
            [self showNoConnectionView];
        }
        
    }else{
        [self alertMessageClicled:cell andShowStartWidth:51 andMessage:@"已点击过"];  //弹出已点击按钮
    }

    
    
}

- (IBAction)badBtnClick:(id)sender {
    FooterTableViewCell * cell = (FooterTableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    
    NSString *md5code=((DuanZi *)[self.myArray objectAtIndex:path.section]).md5code;
    DuanZi *clickDuanzi=[self.myArray objectAtIndex:path.section];
    if ([clickDuanzi.ifAdded boolValue]==NO) {
        if ([self isConnectionAvailable]) {
            //向服务器发送好评的MD5code
            NSString *urlAsString = [NSString stringWithFormat:@"%@/addPoetryBadNumber/md5code=%@",self.serverRootUrl,md5code];
            
            NSString *strURL = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
            [req setHTTPMethod:@"GET"];
            [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            NSError *error=nil;
            NSData *condata=[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
            if ([condata length]>0&& error == nil) {
                [self addPraiseAndBadNumber:condata andError:error andIndex:path.section];  //调用自定义函数修改数据
            }
            
        }else {
            [self showNoConnectionView];
        }
    }else{
    
        [self alertMessageClicled:cell andShowStartWidth:140 andMessage:@"已点击过"];  //弹出已点击按钮
    }

}

#pragma mark 弹出已点击赞或者贬按钮
-(void) alertMessageClicled:(FooterTableViewCell *) cell andShowStartWidth:(CGFloat)startWidth andMessage:(NSString *) message{
    UILabel *animoteLabel=[[UILabel alloc] initWithFrame:CGRectMake(startWidth, 10, 50, 10)];
    animoteLabel.text=message;
    animoteLabel.font=[UIFont systemFontOfSize:7.f];
    animoteLabel.hidden=YES;
    [cell addSubview:animoteLabel];
    if (animoteLabel.hidden==YES) {
        animoteLabel.textColor=[UIColor redColor];
        animoteLabel.backgroundColor=[UIColor clearColor];
        animoteLabel.hidden=NO;
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseInOut
                         animations:^{
                             animoteLabel.frame = CGRectMake(startWidth, 0.f, 50, 10);
                             
                         }
                         completion:^(BOOL finished){
                             if (finished)
                                 [animoteLabel removeFromSuperview];
                         }];
        
    }
}



#pragma mark   获得好评/差评返回数据
-(void) addPraiseAndBadNumber:(NSData *)condata andError:(NSError *)error andIndex:(int) index{
    
    
    id jsonObject2 = [NSJSONSerialization
                      JSONObjectWithData:condata
                      options:NSJSONReadingAllowFragments
                      error:&error];
    
    
    if (jsonObject2 != nil&& error == nil){
        
        NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject2;
        //遍历数据源获得新闻
        
        
        for (id articleclassname in deserializedDictionary) {
            
            
            if ([articleclassname isEqualToString:@"results"]) {   //获得具体内涵段子信息，接着进行解析
                id articleElement=[deserializedDictionary objectForKey:articleclassname];
                DuanZi *duanZi=nil;
                
                for (id everyArticel in articleElement) {//遍历每一篇内涵段子
                    duanZi=[[DuanZi alloc] init];
                    for (id detail in everyArticel) {                      //获得每篇文章的内容
                        
                        id ele=[everyArticel objectForKey:detail];
                        if ([detail isEqualToString:@"article"]) {
                            duanZi.article=ele;
                            duanZi.ifAdded=[NSNumber numberWithBool:YES];
                        }else if ([detail isEqualToString:@"userid"]){
                            duanZi.userid=ele;
                            User *user=[self getUserNameById:ele];
                            duanZi.userInfo=user;
                        }else if ([detail isEqualToString:@"date"]){
                            duanZi.date=ele;
                        }else if ([detail isEqualToString:@"md5code"]){
                            duanZi.md5code=ele;
                        }else if ([detail isEqualToString:@"id"]){
                            duanZi.idnumber=ele;
                        }else if ([detail isEqualToString:@"praisenumber"]){
                            duanZi.praisenumber=ele;
                        }else if ([detail isEqualToString:@"badnumber"]){
                            duanZi.badnumber=ele;
                        }
                        
                    }
                    [itemArray replaceObjectAtIndex:index withObject:duanZi];
                    //[self.ifAddedArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:YES]];
                    
                }//end 遍历每一篇内涵段子
                
            }
        }//end for
    }
    
    self.myArray=itemArray;
    [self.tableView reloadData];
    
    
}

#pragma mark prepareForSegue 进行页面传值
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
       
    if([[segue identifier] isEqualToString:@"commentsegue"]){
        UIViewController *controller;
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
            controller = [navController.viewControllers objectAtIndex:0];
        } else {
            controller = segue.destinationViewController;
        }
        NSIndexPath *selectIndexPath=nil;
    
        if ([sender isKindOfClass:[UIButton class]]) {
            FooterTableViewCell * cell = (FooterTableViewCell *)[[sender superview] superview];
            selectIndexPath = [self.tableView indexPathForCell:cell];

        }else if([sender isKindOfClass:[TextMidCell class]]){
            selectIndexPath = [self.tableView indexPathForSelectedRow];
        }
        DuanZi *nowDuanZi=[self.myArray objectAtIndex:selectIndexPath.section];
        
        if ([controller isKindOfClass:[CommentViewController class]]) {
            CommentViewController *commentViewController = (CommentViewController *)controller;
            
            [commentViewController getPmd5code:nowDuanZi.md5code andFrom:@"poetry"];
        } else {
            NSAssert(NO, @"Unknown segue. All segues must be handled.");
        }//ToAddContent
    }else if ([[segue identifier] isEqualToString:@"ToAddContent"]){
        UIViewController *controller;
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
            controller = [navController.viewControllers objectAtIndex:0];
        } else {
            controller = segue.destinationViewController;
        }
        
        if ([controller isKindOfClass:[EditViewController class]]) {
            EditViewController *editViewController = (EditViewController *)controller;
            [editViewController sendFrom:@"Poetry"];
           
        } else {
            NSAssert(NO, @"Unknown segue. All segues must be handled.");
        }//ToAddContent
    
    }
    
    
}


@end
