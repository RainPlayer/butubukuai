//
//  CommentViewController.m
//  不吐不快
//
//  Created by WildCat on 13-10-10.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentCell.h"
#import "Comment.h"
#import "AddCommentViewController.h"
#import "Reachability.h"
#define BAGCOLOR [UIColor colorWithRed:245.0/255.0 green:223.0/255.0 blue:181.0/255.0 alpha:1.0]
#define TOPBARCOLOR [UIColor colorWithRed:221/255.0f green:170/255.0f blue:59/255.0f alpha:0]
#define TOPCELLCOLOR [UIColor colorWithRed:245.0/255.0 green:243.0/255.0 blue:241.0/255.0 alpha:1.0]

#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH 201.0f
#define CELL_CONTENT_MARGIN 13.0f
#define CELL_CONTENT_LEFTMARGIN 13.0f

@interface CommentViewController ()
@property NSString *Pmd5code;
@property UILabel *tixingLabel;
@property NSString *Paramfrom;
@property NSString *serverUrl;
@end

@implementation CommentViewController
@synthesize myArray;
@synthesize tixingLabel;
@synthesize Paramfrom;
@synthesize serverUrl;
#pragma mark  获得PMD5code
-(void)getPmd5code:(NSString *)pmd5code andFrom:(NSString *)from{
    self.Pmd5code=pmd5code;
    self.Paramfrom=from;
}


#pragma mark 
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
    //设置header of section grouped
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    self.serverUrl=[persistentDefaults objectForKey:@"ServerUrl"];
    
    //异步加载数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getCommentByPmd5codeFromUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 10.f)];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
        [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
    
    CGRect frame = self.tableView.tableHeaderView.frame;
    frame.size.height = 10;
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    [self.tableView setTableHeaderView:headerView];
}

#pragma mark - webservice获得评论信息
-(void) getCommentByPmd5codeFromUrl
{

    NSMutableArray *itemArray=[NSMutableArray array];
    //获得json数据
    NSString *urlAsString =nil;
    if ([self.Paramfrom isEqualToString:@"poetry"]) {//
        urlAsString= [NSString stringWithFormat:@"%@/getPoetryCommentByPmd5code/Pmd5code=%@/?page_size=500",self.serverUrl,self.Pmd5code];
    }else if([self.Paramfrom isEqualToString:@"nhimage"]){
        urlAsString = [NSString stringWithFormat:@"%@/myapp/getNHImageCommentByPid/pid=%@/?page_size=500",self.serverUrl,self.Pmd5code]; //这里其实是从ImageTableViewController 传过来的idnumber
       
    }else{
        urlAsString = [NSString stringWithFormat:@"%@/getNHArtCommentByPmd5code/Pmd5code=%@/?page_size=500",self.serverUrl,self.Pmd5code];
    }
    NSLog(@"comment url::::%@",urlAsString);
    
    
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
            //遍历数据源获得新闻
            
            
            for (id articleclassname in deserializedDictionary) {
                
                
                if ([articleclassname isEqualToString:@"results"]) {   //获得具体内涵段子信息，接着进行解析
                    id articleElement=[deserializedDictionary objectForKey:articleclassname];
                    
                    if ([articleElement count]<=0) {
                        
                        
                        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(50, 10, 300, 30)];
                        label.backgroundColor=BAGCOLOR;
                        label.font=[UIFont systemFontOfSize:12.f];
                        label.textColor=[UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0];
                        if ([self isConnectionAvailable]) {
                             label.text=@"暂时还没有评论,不吐不快右上角。";
                        }else{
                            label.text=@"没有网络连接，请稍后重试。";
                        }
                       
                        self.tixingLabel=label;
                        
                        [self.view addSubview:self.tixingLabel];
                        
                    }
                     Comment *newComment;
                    for (id everyArticel in articleElement) {//遍历每一篇内涵段子
                        newComment=[[Comment alloc] init];
                        for (id detail in everyArticel) {                      //获得每篇文章的内容
                            
                            id ele=[everyArticel objectForKey:detail];
                            if ([detail isEqualToString:@"discuss"]) {
                                newComment.discuss=ele;
                            }else if ([detail isEqualToString:@"observer"]){
                                newComment.observer=ele;
                                newComment.headerImageUrl=[self getHeaderImageByName:newComment.observer];//获得头像路径
                            }else if ([detail isEqualToString:@"date"]){
                                newComment.date=ele;
                                
                            }
                        }
                        //添加到全局数组
                        [itemArray addObject:newComment];
                                               
                    }//end 遍历每一篇内涵段子
                    
                }                
            }//end for
        }
        
        
    }
    self.myArray=itemArray;
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.Paramfrom=nil;
    self.tixingLabel=nil;
    self.Pmd5code=nil;
    self.myArray=nil;
    self.serverUrl=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    Comment *nowComment=[self.myArray objectAtIndex:indexPath.row];
    NSString *text = nowComment.discuss;
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2);

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.myArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *label=nil;
    if (cell==nil) {
        cell=[[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setLineBreakMode:UILineBreakModeWordWrap];
        [label setMinimumFontSize:FONT_SIZE];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [label setTag:1];
        cell.commentLabel=label;
        
    }
    
    Comment *nowComment=[self.myArray objectAtIndex:indexPath.row];
    
    //添加元素
    cell.nameLabel.text=nowComment.observer;
    cell.timerLabel.text=nowComment.date;
    cell.floorLabel.text=[NSString stringWithFormat:@"%d",indexPath.row+1];
    if ([nowComment.headerImageUrl length]>0) {
        [cell setUrlByString:[NSString stringWithFormat:@"%@/media/%@",self.serverUrl,nowComment.headerImageUrl]];
    }
        
    NSString *text = nowComment.discuss;
  
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    if (!cell.commentLabel)
        label = (UILabel*)[cell viewWithTag:1];
    
    [cell.commentLabel setText:text];
   
    [cell.commentLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN+60, CELL_CONTENT_MARGIN+10, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2)+20, MAX(size.height, 44.0f))];
    
    UIView *sectionBagView=[[UIView alloc] initWithFrame:cell.bounds] ;
    cell.backgroundView=sectionBagView;
    if (indexPath.row%2==0) {
        cell.backgroundView.backgroundColor=[UIColor whiteColor];

    }else{
        cell.backgroundView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
    }
    
    
    
    return cell;
}

-(NSString *) getHeaderImageByName:(NSString *)userName{
    
    NSString *urlAsString = [NSString stringWithFormat:@"%@/getUserByName/name=%@",self.serverUrl,userName];
    NSString *strURL = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
                       
                        for (id detail in everyUser) {                      //获得每篇文章的内容
                            
                            id ele=[everyUser objectForKey:detail];
                            if ([detail isEqualToString:@"headerimage"]){
                                return ele;
                            }
                        }
                    }//end 遍历每一篇内涵段子
                    
                }
            }//end for
        }
        
    }
    
    return @"";    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark prepareForSegue 进行页面传值
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([[segue identifier] isEqualToString:@"AddCommentSegue"]){
        UIViewController *controller;
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
            controller = [navController.viewControllers objectAtIndex:0];
        } else {
            controller = segue.destinationViewController;
        }
              
        if ([controller isKindOfClass:[AddCommentViewController class]]) {
            AddCommentViewController *addcommentViewController = (AddCommentViewController *)controller;
            
            [addcommentViewController getPmd5code:self.Pmd5code andFrom:self.Paramfrom];
            
        } else {
            NSAssert(NO, @"Unknown segue. All segues must be handled.");
        }
    }
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
