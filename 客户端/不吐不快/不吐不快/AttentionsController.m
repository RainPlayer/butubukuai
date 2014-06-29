//
//  AttentionsController.m
//  不吐不快
//
//  Created by WildCat on 13-11-1.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import "AttentionsController.h"
#import "AttentionUserCell.h"
#import "User.h"
#import "UserInfoController.h"
#import "Reachability.h"

#define BAGCOLOR [UIColor colorWithRed:245.0/255.0 green:223.0/255.0 blue:181.0/255.0 alpha:1.0]
@interface AttentionsController ()
@property NSString *selfId;
@property NSString *serverUrl;
@end

@implementation AttentionsController
@synthesize usersArray;
@synthesize userId;
@synthesize selfId;
@synthesize serverUrl;
-(void)passUserId:(NSString *)passUserId{
    self.userId=passUserId;

}

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
    
    self.tableView.backgroundColor=BAGCOLOR;
    
    
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    self.selfId=[persistentDefaults objectForKey:@"userId"];
    self.serverUrl=[persistentDefaults objectForKey:@"ServerUrl"];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;  //...
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
   
    
    
    //异步加载数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.usersArray=[self getAttentionUsers];  //获得关注内容
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
    });
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
}
#pragma mark 解析关注好友列表
-(NSMutableArray *) getAttentionUsers{
    
    NSMutableArray *myArray=[NSMutableArray array];
    
    NSString *urlAsString = [NSString stringWithFormat:@"%@/getAttentionDetails/userid=%@",self.serverUrl,self.userId];
    
    NSString *strURL = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    [req setHTTPMethod:@"GET"];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSError *error=nil;
    NSData *condata=[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
    
    if ([condata length] >0 && error == nil){
        id jsonObject2 = [NSJSONSerialization
                          JSONObjectWithData:condata
                          options:NSJSONReadingAllowFragments
                          error:&error];
        if (jsonObject2 != nil&& error == nil){
            
            NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject2;
            
            //遍历数据源获得用户
            for (id classname in deserializedDictionary) {
                if ([classname isEqualToString:@"attentions"]) {
                    id ele=[deserializedDictionary objectForKey:classname];
                    
                    
                    for (id countNumber in ele) {
                        User *nowUser=[[User alloc] init];
                          
                            id detail=[ele objectForKey:countNumber];
                            int mycount=0;
                            for (id userDetail in detail) {   //遍历关注者具体信息
                                mycount++;
                                if (mycount==1) {
                                    nowUser.userid=userDetail;
                                }else if (mycount==2){
                                    nowUser.name=userDetail;
                                }else if (mycount==4){
                                    nowUser.grade=userDetail;
                                }else if (mycount==5){
                                    nowUser.headerimage=userDetail;
                                }
                                
                            }
                        [myArray addObject:nowUser];
                        
                    }
                
                }
            }//end for
        }
        
        
    }

return myArray;

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    self.usersArray=nil;
    self.userId=nil;
    

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.usersArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AttentionUserCell";
    AttentionUserCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    User *userInfo=[self.usersArray objectAtIndex:indexPath.row];
    if (cell==nil) {
        cell=[[AttentionUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.nameLabel.text=userInfo.name;
    cell.gradeLabel.text=userInfo.grade;
    [cell setUrlByString:[NSString stringWithFormat:@"%@/media/%@",self.serverUrl,userInfo.headerimage]];
    
    return cell;
}



#pragma mark - Table view delegate
//要求委托方的编辑风格在表视图的一个特定的位置。
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
     
    
   
    if ([[NSString stringWithFormat:@"%@",self.selfId] isEqualToString:self.userId]) {
        
        if ([tableView isEqual:self.tableView]) {
            result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
        }
        
    }
    return result;
   
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{//请求数据源提交的插入或删除指定行接收者。
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row<[self.usersArray count]) {
            if ([self isConnectionAvailable]) {
                User *deleteUser=[self.usersArray objectAtIndex:indexPath.row];
                //向服务器发送删除好友
                [self deleteAttention:deleteUser.userid];  //应该有返回值
                
                [self.usersArray removeObjectAtIndex:indexPath.row];//移除数据源的数据
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
            }else{
                UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:nil message:@"请查看网络连接。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        
        }
    }
}


#pragma mark  segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UserInfoController *controller=[segue destinationViewController];
    
    NSIndexPath *selectIndexPath = [self.tableView indexPathForSelectedRow];
   User *clickUser=[self.usersArray objectAtIndex:selectIndexPath.row];
    [controller passUserInfo:clickUser];
    
    
    
}
-(void) deleteAttention:(NSNumber *) attentionId{

    NSString *urlAsString = [NSString stringWithFormat:@"%@/deleteAttention/userid=%@&attentionid=%@",self.serverUrl,self.selfId,attentionId];
    
    NSString *strURL = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // requesting weather for this location ...
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    [req setHTTPMethod:@"GET"];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSError *error=nil;
    [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
    
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

@end
