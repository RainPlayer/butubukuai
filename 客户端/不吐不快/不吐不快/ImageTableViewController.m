//
//  ImageTableViewController.m
//  GodTuCaoDemo1
//
//  Created by WildCat on 13-10-5.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import "ImageTableViewController.h"
#import "NeiHanImageClass.h"
#import "HeaderTableCell.h"
#import "FooterTableViewCell.h"
#import "NeiHanImageCell.h"
#import "Reachability.h"
#import "CommentViewController.h"
#import "EditViewController.h"
#import "UserInfoController.h"
#define TOPCELLCOLOR [UIColor colorWithRed:245.0/255.0 green:243.0/255.0 blue:241.0/255.0 alpha:1.0]
#define BAGCOLOR [UIColor colorWithRed:245.0/255.0 green:223.0/255.0 blue:181.0/255.0 alpha:1.0]

#define FONT_SIZE 16.0f
#define CELL_CONTENT_WIDTH 305.0f
#define CELL_CONTENT_MARGIN 10.0f
#define IMAGEHEIGHT 100.0f


@interface ImageTableViewController ()<EGORefreshTableHeaderDelegate>
@property NSMutableArray *itemArray;
@property NSString *urlString;
@property int page;
@property NSString *serverUrl;
@end

@implementation ImageTableViewController
@synthesize myArray;
@synthesize itemArray;
@synthesize urlString;
@synthesize page;
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
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    //下拉刷新
    if (_refreshHeaderView==nil) {
        //初始化下拉刷新空间
        EGORefreshTableHeaderView *view1=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 10.0f-self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.view.bounds.size.height)];
        view1.delegate = self;
        [self.tableView addSubview:view1];
        _refreshHeaderView = view1;
    }
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    self.serverUrl=[persistentDefaults objectForKey:@"ServerUrl"];

    
    self.urlString=[NSString stringWithFormat:@"%@/myapp/btbkimage/",self.serverUrl];
    self.page=1;
    

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self parserNeiHanImage];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
    });
    
  
    
}

#pragma mark - 解析
#pragma mark 解析内涵段子具体信息
-(void) parserNeiHanImage
{
    
    if (self.itemArray==nil) {
        self.itemArray=[NSMutableArray array];
    }
    
    //获得json数据
    
    NSString *urlAsString = self.urlString;
    
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
        if (jsonObject2 != nil&& error == nil){
            
            NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject2;
            //遍历数据源获得新闻
            
            
            for (id articleclassname in deserializedDictionary) {
                
                
                if ([articleclassname isEqualToString:@"results"]) {   //获得具体内涵段子信息，接着进行解析
                    id articleElement=[deserializedDictionary objectForKey:articleclassname];
                    NeiHanImageClass *neiHanImageClass=nil;
                    
                    for (id everyArticel in articleElement) {//遍历每一篇内涵段子
                        neiHanImageClass=[[NeiHanImageClass alloc] init];
                        for (id detail in everyArticel) {                      //获得每篇文章的内容
                            
                            id ele=[everyArticel objectForKey:detail];
                            if ([detail isEqualToString:@"article"]) {
                                neiHanImageClass.article=ele;
                                neiHanImageClass.ifAdded=[NSNumber numberWithBool:NO]; //初始化为点赞或者贬按钮
                                neiHanImageClass.ifCollected=[NSNumber numberWithBool:NO];//初始化为点收藏按钮
                                
                            }else if ([detail isEqualToString:@"date"]){
                                neiHanImageClass.date=ele;
                            }else if ([detail isEqualToString:@"id"]){
                                neiHanImageClass.idnumber=ele;
                            }else if ([detail isEqualToString:@"praisenumber"]){
                                neiHanImageClass.praisenumber=ele;
                            }else if ([detail isEqualToString:@"badnumber"]){
                                neiHanImageClass.badnumber=ele;
                            }else if ([detail isEqualToString:@"username"]){
                                neiHanImageClass.username=ele;
                                User *userInfo=[self getUserInfoByName:ele];
                                neiHanImageClass.userInfo=userInfo;
                               
                            }else if ([detail isEqualToString:@"docfile"]){
                                neiHanImageClass.imageUrl=[NSString stringWithFormat:@"%@/media/%@",self.serverUrl,ele];
                            }else if ([detail isEqualToString:@"imagewidth"]){
                                neiHanImageClass.imagewidth=ele;
                            }else if ([detail isEqualToString:@"imageheight"]){
                                neiHanImageClass.imageHeight=ele;
                            }
                            
                        }
                        [itemArray insertObject:neiHanImageClass atIndex:0];
                        
                    }//end 遍历每一篇内涵段子
                    
                }else if ([articleclassname isEqualToString:@"next"]){// end   获得具体内涵段子信息，接着进行解析
                    // id nextArticelUrl=[deserializedDictionary objectForKey:articleclassname];
                    NSString *nextUrl=[NSString stringWithFormat:@"%@/myapp/btbkimage/?page=%d",self.serverUrl,++self.page];
                    self.urlString=nextUrl;
                    
                }
                
            }//end for
        }
        
        
    }
    
    self.myArray=itemArray;
    
    
}

-(User *) getUserInfoByName:(NSString *)userName{
    
    NSString *urlAsString = [NSString stringWithFormat:@"%@/getUserByName/name=%@",self.serverUrl,userName];
    NSString *strURL = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    User *infoOfUser=[[User alloc] init];
    NSURL *url = [NSURL URLWithString:strURL];
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
            //遍历数据源获得用户
            for (id userclassname in deserializedDictionary) {
                if ([userclassname isEqualToString:@"results"]) {   //获得具体内涵段子信息，接着进行解析
                    id userElement=[deserializedDictionary objectForKey:userclassname];
                    for (id everyUser in userElement) {//遍历每一篇内涵段子
                        infoOfUser=[[User alloc] init];
                        for (id detail in everyUser) {                      //获得每篇文章的内容
                            
                            id ele=[everyUser objectForKey:detail];
                            if ([detail isEqualToString:@"name"]) {
                                infoOfUser.name=ele;
                            }else if ([detail isEqualToString:@"password"]){
                                infoOfUser.password=ele;
                            }else if ([detail isEqualToString:@"id"]){
                                infoOfUser.userid=ele;
                            }else if ([detail isEqualToString:@"grade"]){
                                infoOfUser.grade=ele;
                            }else if ([detail isEqualToString:@"headerimage"]){
                                infoOfUser.headerimage=ele;
                               
                            }
                            
                        }
                    }//end 遍历每一篇内涵段子
                    
                }
            }//end for
        }
        
    }
    
    return infoOfUser;
    
    
}

//ios7的navigationbar默认是透明的，所以当下拉刷新后会出现挡住的情况，下面可以解决
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置NivagationItem挡住的问题
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
        [self setEdgesForExtendedLayout:UIRectEdgeBottom];

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 10.f)];
}

#pragma mark - 注销
- (void)viewDidUnload
{
    
    [super viewDidUnload];
    self.myArray=nil;
    self.itemArray=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=0.f;
    NeiHanImageClass *nowNHImageClass=[self.myArray objectAtIndex:indexPath.section];
    

    
    if (indexPath.row%3==1) {
        NSString *text = nowNHImageClass.article;
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat height = MAX(size.height, 44.0f);
        
        return height + (CELL_CONTENT_MARGIN * 2)+[nowNHImageClass.imageHeight floatValue];
    }else {
        height=37.f;
    }
    return height;
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.myArray.count;
    
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
    NeiHanImageClass *nhImageClass=[self.myArray objectAtIndex:tapIndexPath.section];  //获得当前点击的图像
    
    [userInfoController passUserInfo:nhImageClass.userInfo];
    
    [self.navigationController pushViewController:userInfoController animated:YES];
}


#pragma mark 为cell添加信息
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"HeaderTableCell";
    static NSString *MidCellIdentifier = @"NeiHanImageCell";
    static NSString *FootCellIdentifier = @"FootCell";
    HeaderTableCell *headerCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //ImageTableViewCell *middleCell= [tableView dequeueReusableCellWithIdentifier:MidCellIdentifier];
    NeiHanImageCell *middleCell=[tableView dequeueReusableCellWithIdentifier:MidCellIdentifier];

    FooterTableViewCell *footCell=[tableView dequeueReusableCellWithIdentifier:FootCellIdentifier];
    NeiHanImageClass *nowNHImageClass=[self.myArray objectAtIndex:indexPath.section];
    
    
   
    if (indexPath.row%3==0) {
        if (headerCell==nil) {
            headerCell=[[HeaderTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        headerCell.timerLabel.text=nowNHImageClass.date;
        if ([nowNHImageClass.userInfo.headerimage length]>0) {
        [headerCell setUrlByString:[NSString stringWithFormat:@"%@/media/%@",self.serverUrl,nowNHImageClass.userInfo.headerimage]];
        }
        headerCell.nameLabel.text=nowNHImageClass.username;
        UIView *sectionBagView=[[UIView alloc] initWithFrame:headerCell.bounds] ;
        headerCell.backgroundView=sectionBagView;
        headerCell.backgroundView.backgroundColor=TOPCELLCOLOR;
        UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserHeaderImageSendUserInfo:)];
        [headerCell addUITapGestureRecognizer:singleTap]; //添加触摸手势识别

        
        return headerCell;
    }else if(indexPath.row%3==1) {
        UILabel *label = nil;

        if (middleCell==nil) {
            middleCell=[[NeiHanImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MidCellIdentifier];
            
            label = [[UILabel alloc] initWithFrame:CGRectZero];
            [label setLineBreakMode:UILineBreakModeWordWrap];
            [label setMinimumFontSize:FONT_SIZE];
            [label setNumberOfLines:0];
            [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
           // middleCell.titleLabel=label;
             [[middleCell contentView] addSubview:label];//label 显示出来，如果用上边的则显示不出来
        }
               
        
        [middleCell setUrlByString:nowNHImageClass.imageUrl];
       
        //设置背景颜色
        UIView *sectionBagView=[[UIView alloc] initWithFrame:middleCell.bounds] ;
        middleCell.backgroundView=sectionBagView;
        middleCell.backgroundView.backgroundColor=[UIColor whiteColor];
        
        NSString *text =nowNHImageClass.article;
        //设置字体高度
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        if (! middleCell.titleLabel){
           
             middleCell.titleLabel = (UILabel*)[middleCell viewWithTag:1];
        }
        
        [middleCell setTitleLabelText:text];   
        
        [middleCell.titleLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];  //设置label的fram
        //下面设置ImageView的显示，图片宽度设置为255，高度为按比例缩放。
        [middleCell setBtbkImageViewFram:CGRectMake(CELL_CONTENT_MARGIN+12, MAX(size.height, 44.0f)+20, 255, (255*[nowNHImageClass.imageHeight floatValue])/[nowNHImageClass.imagewidth floatValue])];//设置图片的frame
       
       //设置选中后的背景颜色
        middleCell.selectedBackgroundView=[[UIView alloc]initWithFrame:middleCell.frame];
        middleCell.selectedBackgroundView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:231.0/255.0 blue:221.0/255.0 alpha:1.0];
        

        return middleCell;
        
    }else if(indexPath.row%3==2){
        if (footCell==nil) {
            footCell=[[FooterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FootCellIdentifier];
        }
     
       // footCell.commentBtn.titleLabel.text=@"32";
        UIView *sectionBagView=[[UIView alloc] initWithFrame:footCell.bounds] ;
        footCell.backgroundView=sectionBagView;
        footCell.backgroundView.backgroundColor=[UIColor whiteColor];
        
        footCell.praisenumberLabel.text=[NSString stringWithFormat:@"%@",nowNHImageClass.praisenumber];
        footCell.badnumberLabel.text=[NSString stringWithFormat:@"%@",nowNHImageClass.badnumber];

        
        
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
    [self parserNeiHanImage];
    //后台操作线程执行完后，到主线程更新UI
    [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:YES];
    
}


//重新加载时调用
- (void)reloadTableViewDataSource{
   // NSLog(@"==开始加载数据");
    _reloading = YES;
    [NSThread detachNewThreadSelector:@selector(doInBackground) toTarget:self withObject:nil];
}

//完成加载时调用的方法

- (void)doneLoadingTableViewData{
    //NSLog(@"===加载完数据");
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self.tableView reloadData];  //重新加载
}
#pragma mark 点击好评按钮
- (IBAction)praiseBtnClick:(id)sender {
    FooterTableViewCell * cell = (FooterTableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    int idNumber=[((NeiHanImageClass *)[self.myArray objectAtIndex:path.section]).idnumber intValue];
    
    NeiHanImageClass *clickNHImage=[self.myArray objectAtIndex:path.section];
    if ([clickNHImage.ifAdded boolValue]==NO) {
        if ([self isConnectionAvailable]) {
            //向服务器发送好评的MD5code
            NSString *urlAsString = [NSString stringWithFormat:@"%@/myapp/addNHImagePraiseNumber/id=%d",self.serverUrl,idNumber];
            
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
        [self alertMessageClicled:cell andShowStartWidth:60 andMessage:@"已点击过"]; //弹出已点击按钮
    }

    
}
#pragma mark 点击差评按钮
- (IBAction)badBtnClick:(id)sender {
    FooterTableViewCell * cell = (FooterTableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    
    int idNumber=[((NeiHanImageClass *)[self.myArray objectAtIndex:path.section]).idnumber intValue];
    NeiHanImageClass *clickNHImage=[self.myArray objectAtIndex:path.section];

    if ([clickNHImage.ifAdded boolValue]==NO) {
        if ([self isConnectionAvailable]) {
            //向服务器发送好评的MD5code
           NSString *urlAsString = [NSString stringWithFormat:@"%@/myapp/addNHImageBadNumber/id=%d",self.serverUrl,idNumber];
            
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
        [self alertMessageClicled:cell andShowStartWidth:139 andMessage:@"已点击过"]; //弹出已点击按钮
    }

    
}
#pragma mark 点击收藏按钮
- (IBAction)collectBtnClick:(id)sender {
    
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name=[persistentDefaults objectForKey:@"userName"];
    FooterTableViewCell * cell = (FooterTableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    
    NeiHanImageClass *clickNHImage=[self.myArray objectAtIndex:path.section];
    NSRange range=[clickNHImage.imageUrl rangeOfString:@"documents"];
    NSString *imageUrl=[clickNHImage.imageUrl substringFromIndex:range.location];
   
    
    if ([name length]>0) { //已登录
        if ([clickNHImage.ifCollected boolValue]==NO) {
                        
            NSString *urlAsString = [NSString stringWithFormat:@"%@/addCollection/collector=%@&collectiontype=%@&pid=%@&pmd5code=%@&content=%@&imageurl=%@",self.serverUrl,name,@"nhimage",clickNHImage.idnumber,@"",clickNHImage.article,imageUrl];
            
            NSString *strURL = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
            [req setHTTPMethod:@"GET"];
            [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            NSError *error=nil;
            NSData *condata=[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
            if ([condata length]>0&& error == nil) {
                [self alertMessageClicled:cell andShowStartWidth:270.f andMessage:@"收藏成功"];
                clickNHImage.ifCollected=[NSNumber numberWithBool:YES];
                [self.myArray replaceObjectAtIndex:path.section withObject:clickNHImage];  //把是否收藏改为YES
            }
        }
    }else{
        //弹出未登录对话框
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:@"登陆后收藏" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }

    
    
}

#pragma mark   获得好评差评返回数据
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
                NeiHanImageClass *neiHanImageClass=nil;
                
                for (id everyArticel in articleElement) {//遍历每一篇内涵段子
                    neiHanImageClass=[[NeiHanImageClass alloc] init];
                    for (id detail in everyArticel) {                      //获得每篇文章的内容
                        
                        id ele=[everyArticel objectForKey:detail];
                        if ([detail isEqualToString:@"article"]) {
                            neiHanImageClass.article=ele;
                            neiHanImageClass.ifAdded=[NSNumber numberWithBool:YES];
                        }else if ([detail isEqualToString:@"date"]){
                            neiHanImageClass.date=ele;
                        }else if ([detail isEqualToString:@"id"]){
                            neiHanImageClass.idnumber=ele;
                        }else if ([detail isEqualToString:@"praisenumber"]){
                            neiHanImageClass.praisenumber=ele;
                        }else if ([detail isEqualToString:@"badnumber"]){
                            neiHanImageClass.badnumber=ele;
                        }else if ([detail isEqualToString:@"username"]){
                            neiHanImageClass.username=ele;
                        }else if ([detail isEqualToString:@"docfile"]){
                            neiHanImageClass.imageUrl=[NSString stringWithFormat:@"%@/media/%@",self.serverUrl,ele];
                        }else if ([detail isEqualToString:@"imagewidth"]){
                            neiHanImageClass.imagewidth=ele;
                        }else if ([detail isEqualToString:@"imageheight"]){
                            neiHanImageClass.imageHeight=ele;
                        }
                        
                    }
                    [itemArray replaceObjectAtIndex:index withObject:neiHanImageClass];
                    //[self.ifAddedArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:YES]];
                    
                }//end 遍历每一篇内涵段子
                
            }
        }//end for
    }
    
    self.myArray=itemArray;
    [self.tableView reloadData];
    
    
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

#pragma mark prepareForSegue 进行页面传值
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
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
        
    }else if([sender isKindOfClass:[NeiHanImageCell class]]){
        selectIndexPath = [self.tableView indexPathForSelectedRow];
    }
    NeiHanImageClass *nowNeiHanImage=[self.myArray objectAtIndex:selectIndexPath.section];
    
    
    
    if([[segue identifier] isEqualToString:@"commentsegue"]){
        
        if ([controller isKindOfClass:[CommentViewController class]]) {
            CommentViewController *commentViewController = (CommentViewController *)controller;
            
            [commentViewController getPmd5code:[NSString stringWithFormat:@"%@",nowNeiHanImage.idnumber] andFrom:@"nhimage"];
        } else {
            NSAssert(NO, @"Unknown segue. All segues must be handled.");
        }//ToAddContent
    }else if ([[segue identifier] isEqualToString:@"ToEditSegue"]){
        
    }
    
    
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
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
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



@end
