//
//  UserInfoController.m
//  不吐不快
//
//  Created by WildCat on 13-10-31.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import "UserInfoController.h"
#import "User.h"
#import "EGOImageView.h"
#import "MyProductionViewController.h"
#import "CollectionController.h"
#import <QuartzCore/QuartzCore.h>
#import "AttentionsController.h"
#define TOPBARCOLOR [UIColor colorWithRed:221/255.0f green:170/255.0f blue:59/255.0f alpha:0]
#define BAGCOLOR [UIColor colorWithRed:245.0/255.0 green:223.0/255.0 blue:181.0/255.0 alpha:1.0]

@interface UserInfoController ()<UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property User *userInfo;
@property NSString *selfId;
@property NSNumber *ifAttentioned;
@property NSString *serverUrl;
@end

@implementation UserInfoController
@synthesize myTableView;
@synthesize headerImageView;
@synthesize topView;
@synthesize guanZhuBtn;
@synthesize userNameLabel;
@synthesize gradeLable;
@synthesize userInfo;
@synthesize myAlertLabel;
@synthesize selfId;
@synthesize ifAttentioned;
@synthesize serverUrl;


-(void)passUserInfo:(User *)passUserInfo{
    self.userInfo=passUserInfo;
   

}
-(void) setUrlByString:(NSString *) urlStr{
    self.headerImageView.imageURL=[NSURL URLWithString:urlStr];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    selfId=[persistentDefaults objectForKey:@"userId"];
    self.serverUrl=[persistentDefaults objectForKey:@"ServerUrl"];
    
	headerImageView.layer.cornerRadius = 31;
    headerImageView.layer.masksToBounds = YES;
    self.myTableView.scrollEnabled=NO;
    self.myTableView.dataSource=self;
    self.myTableView.delegate=self;
	UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.topView.frame.size.width, 110)];
    
    contentView.image=[UIImage imageNamed:@"6.jpeg"];
    
    [self.topView addSubview:contentView];
    [self.topView sendSubviewToBack:contentView];
    self.topView.backgroundColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:220.0/255.0 alpha:1.0];
    [self.myTableView setBackgroundColor:BAGCOLOR];
    self.userNameLabel.text=self.userInfo.name;
    self.gradeLable.text=self.userInfo.grade;
    [self setUrlByString:[NSString stringWithFormat:@"%@/media/%@",self.serverUrl,self.userInfo.headerimage]];
    self.myAlertLabel.hidden=YES;
    [self getIfAttentioned];

    
    if ([self.ifAttentioned intValue]==1) {  //为关注
        self.guanZhuBtn.hidden=YES;
    }
    
}


#pragma mark 判断是否关注此人，关注返回1
-(void)getIfAttentioned{
        
    NSString *urlAsString = [NSString stringWithFormat:@"%@/ifAttentioned/userid=%@&attentionid=%@",self.serverUrl,self.selfId,self.userInfo.userid];
    
    NSString *strURL = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // requesting weather for this location ...
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
                if ([classname isEqualToString:@"count"]) {
                    id ele=[deserializedDictionary objectForKey:classname];
                    self.ifAttentioned =ele;
                }
            }//end for
        }
        
        
    }
}



- (void)viewDidUnload
{
    
    [self setMyTableView:nil];
    [self setHeaderImageView:nil];
    [self setGuanZhuBtn:nil];
    [self setUserNameLabel:nil];
    [self setGradeLable:nil];
    [self setTopView:nil];
    self.myAlertLabel=nil;
    self.guanZhuBtn=nil;
    self.ifAttentioned=nil;
    self.selfId=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark 点击关注按钮
- (IBAction)guanzhuBtnClick:(id)sender {   //判断是否登陆？？？
    
   
    if (self.selfId!=nil) {
        if (self.myAlertLabel.hidden==YES) {
            self.myAlertLabel.textColor=[UIColor redColor];
            self.myAlertLabel.hidden=NO;
            [UIView animateWithDuration:0.5  //动画时间
                                  delay:0.1  //开始延迟时间
                                options: UIViewAnimationCurveEaseInOut  //弹入弹出
                             animations:^{
                                 self.myAlertLabel.font=[UIFont systemFontOfSize:8.f];
                                 self.myAlertLabel.frame = CGRectMake(268, 115, 46, 15);  //终止高度设的小于起始高度
                                 
                             }
                             completion:^(BOOL finished){
                                 if (finished)
                                     [self.myAlertLabel removeFromSuperview];  //移动后隐藏
                                    
                             }];
            
        }
        
        //发送关注信息
        [self sendAttentionMessageToServer:[NSString stringWithFormat:@"%@",self.selfId]];
        self.guanZhuBtn.hidden=YES;
    }
        
}
#pragma mark 发送关注信息
-(void) sendAttentionMessageToServer:(NSString *)selfUserId{
    
        
    NSString *urlAsString = [NSString stringWithFormat:@"%@/addAttention/userid=%@&attentionid=%@",self.serverUrl,selfUserId,self.userInfo.userid];
    
    NSString *strURL = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // requesting weather for this location ...
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    [req setHTTPMethod:@"GET"];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSError *error=nil;
    [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];


}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=37.f;
    
    return height;
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return 3;
}
#pragma  mark 添加cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *ProductionCellIdentifier = @"ProductionCell";
    static NSString *CollectionCellIdentifier = @"CollectionCell";
    static NSString *AttentionCellIdentifier = @"AttentionCell";
    
    UITableViewCell *productionCell= [tableView dequeueReusableCellWithIdentifier:ProductionCellIdentifier];
    UITableViewCell *collectionCell= [tableView dequeueReusableCellWithIdentifier:CollectionCellIdentifier];
    UITableViewCell *attentionCell= [tableView dequeueReusableCellWithIdentifier:AttentionCellIdentifier];
    if (indexPath.row==0) {
        
        if (productionCell==nil) {
            productionCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProductionCellIdentifier];
        }
        productionCell.textLabel.text=@"我的投稿";
        
        id count=[self getProductionNumber]; //投稿的个数
        if (count!=nil) {
            productionCell.detailTextLabel.text=[NSString stringWithFormat:@"%@",count];
        }else{
            productionCell.detailTextLabel.text=@"0";
        }
        return productionCell;
    }else if (indexPath.row==1){
        
        if (collectionCell==nil) {
            collectionCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CollectionCellIdentifier];
        }
        collectionCell.textLabel.text=@"我收藏的";
        
        id count=[self getCollectionNumber]; //获得收藏的个数
        if (count!=nil) {
            collectionCell.detailTextLabel.text=[NSString stringWithFormat:@"%@",count];
        }else{
            collectionCell.detailTextLabel.text=@"0";
        }
        return collectionCell;
    }else if (indexPath.row==2){
        
        if (attentionCell==nil) {
            attentionCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AttentionCellIdentifier];
        }
        
        attentionCell.textLabel.text=@"我关注的";
        id count=[self getAttentionNumber]; //获得收藏的个数
        if (count!=nil) {
            attentionCell.detailTextLabel.text=[NSString stringWithFormat:@"%@",count];
        }else{
            attentionCell.detailTextLabel.text=@"0";
        }
       
        return attentionCell;
    }
    return productionCell;
}

#pragma mark 获得关注的个数
-(id) getAttentionNumber{
    id attentionCount=nil;
    if([self.userInfo.name length]>0){
        NSString *urlAsString = [NSString stringWithFormat:@"%@/getAttentionCount/userid=%@",self.serverUrl,self.userInfo.userid];
        
        NSString *strURL = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        // requesting weather for this location ...
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
                    if ([classname isEqualToString:@"count"]) {
                        id ele=[deserializedDictionary objectForKey:classname];
                        attentionCount =ele;
                    }
                }//end for
            }
            
            
        }
    }
    
    return attentionCount;
}

#pragma mark 获得收藏的个数
-(id) getCollectionNumber{
    id collectionCount=nil;
    if([self.userInfo.name length]>0){
        NSString *urlAsString = [NSString stringWithFormat:@"%@/getCollectionNumberByName/collector=%@",self.serverUrl,self.userInfo.name];
        
        NSString *strURL = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        // requesting weather for this location ...
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
                    if ([classname isEqualToString:@"count"]) {
                        id ele=[deserializedDictionary objectForKey:classname];
                        collectionCount =ele;
                    }
                }//end for
            }
            
            
        }        
    }
    
    return collectionCount;
}
#pragma mark 获得投稿的个数
-(id) getProductionNumber{
    id collectionCount=nil;
    if([self.userInfo.name length]>0){
                
        NSString *urlAsString = [NSString stringWithFormat:@"%@/getProductionNumber/name=%@&id=%@",self.serverUrl,self.userInfo.name,self.userInfo.userid];
        
        NSString *strURL = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        // requesting weather for this location ...
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
                    if ([classname isEqualToString:@"count"]) {
                        id ele=[deserializedDictionary objectForKey:classname];
                        collectionCount =ele;
                    }
                    
                    
                }//end for
            }
            
            
        }else{
            NSLog(@"%@",error);
        }
        
    }
    
    return collectionCount;
}
#pragma mark 页面跳转传值
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"ToCollection"]){
        CollectionController *controller=[segue destinationViewController];
        [controller passUserInfo:self.userInfo];
        
    } else if([[segue identifier] isEqualToString:@"ToProduction"]){
        MyProductionViewController *controller=[segue destinationViewController];
        [controller passUserInfo:self.userInfo];
    }else if([[segue identifier] isEqualToString:@"ToAttention"]){ //ToAttention
        AttentionsController *controller=[segue destinationViewController];
        [controller passUserId:[NSString stringWithFormat:@"%@",self.userInfo.userid]];
    }


}

@end
