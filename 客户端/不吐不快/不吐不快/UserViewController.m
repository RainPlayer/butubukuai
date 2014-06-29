//
//  UserViewController.m
//  GodTuCaoDemo1
//
//  Created by WildCat on 13-10-5.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import "UserViewController.h"
#import "EGOImageView.h"
#import "Reachability.h"
#import "MyProductionViewController.h"
#import "CollectionController.h"
#import "AttentionsController.h"
#import <QuartzCore/QuartzCore.h>
#define TOPBARCOLOR [UIColor colorWithRed:221/255.0f green:170/255.0f blue:59/255.0f alpha:0]
#define BAGCOLOR [UIColor colorWithRed:245.0/255.0 green:223.0/255.0 blue:181.0/255.0 alpha:1.0]
@interface UserViewController ()<UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property UIImage *uploadImage;
@property NSString *uploadImageName;
@property UIImageView *smallimage;
@property NSString *serverUrl;
@property bool isShown;
@property NSString *userName;
@end

@implementation UserViewController
@synthesize userName;
@synthesize smallimage,uploadImage,uploadImageName;
@synthesize myTableView;
@synthesize topUserView;
@synthesize headImageView;
@synthesize nameLabel;
@synthesize gradeLabel;
@synthesize topNavigationBar;
@synthesize userInfo;
@synthesize isShown;
@synthesize serverUrl;
-(void) setUrlByString:(NSString *) urlStr{
    self.headImageView.imageURL=[NSURL URLWithString:urlStr];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark 视图将要加载
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.topNavigationBar= self.navigationController.navigationBar;
//    self.topNavigationBar.tintColor=TOPBARCOLOR;
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    self.serverUrl=[persistentDefaults objectForKey:@"ServerUrl"];

    headImageView.layer.cornerRadius = 31;
    headImageView.layer.masksToBounds = YES;
    self.myTableView.scrollEnabled=NO;
   
   
       
    self.myTableView.dataSource=self;
    self.myTableView.delegate=self;
	UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.topUserView.frame.size.width, 110)];
   
    contentView.image=[UIImage imageNamed:@"6.jpeg"];
    
    [self.topUserView addSubview:contentView];
    [self.topUserView sendSubviewToBack:contentView];
    self.topUserView.backgroundColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:220.0/255.0 alpha:1.0];
   
    
    [self.myTableView setBackgroundColor:BAGCOLOR];
    //添加点击事件
    self.headImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserHeaderImage)];
    
    [self.headImageView addGestureRecognizer:singleTap]; //添加单击
    
    //获得当前用户名
    NSString *name=[persistentDefaults objectForKey:@"userName"];
    NSString *grade=[persistentDefaults objectForKey:@"userGrade"];
    NSString *userId=[persistentDefaults objectForKey:@"userId"];
    NSString *userHeaderImage=[persistentDefaults objectForKey:@"userHeaderImage"];
    self.userName=name;
    if (self.userInfo==nil) {
        self.userInfo=[[User alloc] init];
        self.userInfo.name=name;
        self.userInfo.grade=grade;
        self.userInfo.userid=[NSNumber numberWithInt:[userId intValue]];
        self.userInfo.headerimage=userHeaderImage;
    }
    
    if ([self.userName length]<=0) {
        [self.logOutBtn setHidden:YES];
    }else{
        [self.loginBarBtnItem setEnabled:NO];
    }
    
}
#pragma mark 弹出打开相册按钮
-(void) clickUserHeaderImage{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"打开相机"
                                            otherButtonTitles:@"打开本地相册",@"取消", nil];
    [alertView show];
   
    
    UIView *additonBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertView.frame.size.width-30, alertView.frame.size.height-20)];
    additonBackgroundView.backgroundColor = [UIColor colorWithRed:225/255.0f green:198/255.0f blue:153/255.0f alpha:1.0]; //添加背景se
    
    [alertView insertSubview:additonBackgroundView atIndex:1];
}

-(void)willPresentAlertView:(UIAlertView *)alertView {
  
    for( UIView * view in alertView.subviews )
    {
        if( [view isKindOfClass:[UILabel class]] )
        {
            
        }
        if ( [view isKindOfClass:[UIButton class]] ){
            UIButton *button=(UIButton*) view;
            button.titleLabel.font=[UIFont systemFontOfSize:18];

            button.titleLabel.textColor=[UIColor blackColor];
       }
    }
}

#pragma mark 获得用户点击了那个按钮

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self takePhoto];
    }else if (buttonIndex==1) {
        [self LocalPhoto];
    
    }

}
#pragma mark  开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        [self presentModalViewController:picker animated:YES];
    }else
    {
      //  NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

#pragma mark 打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentModalViewController:picker animated:YES];
    
}
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //获得当前时间
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmssSSSS"];
        NSString *dateTime = [formatter stringFromDate:[NSDate date]];
        self.uploadImageName=[NSString stringWithFormat:@"%@.png",dateTime];  //设置上传图片的名字
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@",self.uploadImageName]] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@/%@",DocumentsPath,  self.uploadImageName];
        
        
        //关闭相册界面
        [picker dismissModalViewControllerAnimated:YES];
        self.uploadImage=[UIImage imageWithData:data];
        NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
        NSString *userid=[persistentDefaults objectForKey:@"userId"];
        
        if (userid!=nil) {
            if ([self isConnectionAvailable]) {
                 [self uploadNaiHanImageWithUserID:userid andImage:self.uploadImage];
            }else{
                UIAlertView *aletView=[[UIAlertView alloc] initWithTitle:@"友情提示" message:@"请检查网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [aletView show];
            
            }
           
        }
        
    }
    
}
#pragma mark 取消选择图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
   
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark 上传文件 通过用户名，文章 ，图片名
-(void) uploadNaiHanImageWithUserID:(NSString *) useid  andImage:(UIImage *)image{
    NSString *imageString=self.uploadImageName;//获得上传文件名
    
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:[NSString stringWithFormat:@"1.0"] forKey:[NSString stringWithFormat:@"ver"]];
    [_params setObject:[NSString stringWithFormat:@"en"] forKey:[NSString stringWithFormat:@"lan"]];
    [_params setObject:useid forKey:[NSString stringWithFormat:@"id"]];   //添加文本值
   
    
    
    NSString *BoundaryConstant = [NSString stringWithFormat:@"QPiYnJi19ZBYHjkoKQKagYMKSLsyN5J9"];
    
    NSURL* requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/myapp/userheaderimageupload/",self.serverUrl]];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; id=\"id_headerimage\"; name=\"headerimage\"; filename=\"%@\"\r\n",imageString] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if (returnData!=nil) {
       // NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        self.headImageView.image=image;//设置本地头像
        
        NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
        [persistentDefaults setObject:[NSString stringWithFormat:@"headerimage/%@",self.uploadImageName] forKey:@"userHeaderImage"];
    }
}


#pragma mark viewwillapper
-(void)viewWillAppear:(BOOL)animated{
    
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name=[persistentDefaults objectForKey:@"userName"];
    NSString *grade=[persistentDefaults objectForKey:@"userGrade"];
    NSString *userId=[persistentDefaults objectForKey:@"userId"];
    NSString *userHeaderImage=[persistentDefaults objectForKey:@"userHeaderImage"];
    self.userName=name;
    
    
    if (self.userInfo==nil) {
        self.userInfo=[[User alloc] init];
    }
    self.userInfo.name=name;
    self.userInfo.grade=grade;
    self.userInfo.userid=[NSNumber numberWithInt:[userId integerValue]];
    
    if ([name length]<=0) {  //设置按钮
        [self.logOutBtn setHidden:YES];
        [self.loginBarBtnItem setEnabled:YES];
    }else{
        [self.logOutBtn setHidden:NO];
        [self.loginBarBtnItem setEnabled:NO];
    }
  
    if ([name length]<=0) {
        name=@"未登录";
    }
   
    
    
    
    self.nameLabel.text=name;
    self.gradeLabel.text=grade;
    if ([userHeaderImage length]>0&&userHeaderImage!=nil) {
        [self setUrlByString:[NSString stringWithFormat:@"%@/media/%@",self.serverUrl,userHeaderImage]];
    }
    
    //异步加载数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
        });
    });
    

}
- (void)viewDidUnload
{
    [self setMyTableView:nil];
    self.userName=nil;
    [self setTopUserView:nil];
    [self setHeadImageView:nil];
    [self setUserInfo:nil];
    [self setNameLabel:nil];
    [self setGradeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId=[persistentDefaults objectForKey:@"userId"];
    
    if(userId!=nil){
        NSString *urlAsString = [NSString stringWithFormat:@"%@/getAttentionCount/userid=%@",self.serverUrl,userId];
        
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
    if([self.userName length]>0){
        NSString *urlAsString = [NSString stringWithFormat:@"%@/getCollectionNumberByName/collector=%@",self.serverUrl,self.userName];
        
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
#pragma mark 获得投稿的个数
-(id) getProductionNumber{
    id collectionCount=nil;
    if([self.userName length]>0){
        
        NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
        NSString *userId=[persistentDefaults objectForKey:@"userId"];
        
        NSString *urlAsString = [NSString stringWithFormat:@"%@/getProductionNumber/name=%@&id=%@",self.serverUrl,self.userName,userId];
        
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

#pragma mark segue设置
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults]; //获得当前用户名
    NSString *name=[persistentDefaults objectForKey:@"userName"];
    NSString *grade=[persistentDefaults objectForKey:@"userGrade"];
    NSString *userId=[persistentDefaults objectForKey:@"userId"];
    NSString *userHeaderImage=[persistentDefaults objectForKey:@"userHeaderImage"];
    self.userName=name;
    
      User *nowUser=[[User alloc] init];
        nowUser.name=name;
        nowUser.grade=grade;
        nowUser.userid=[NSNumber numberWithInt:[userId intValue]];
        nowUser.headerimage=userHeaderImage;

    if([[segue identifier] isEqualToString:@"ToCollection"]){
        CollectionController *controller=[segue destinationViewController];
        [controller passUserInfo:nowUser];
        
    } else if([[segue identifier] isEqualToString:@"ToProduction"]){
        MyProductionViewController *controller=[segue destinationViewController];
        [controller passUserInfo:nowUser];
    }else if([[segue identifier] isEqualToString:@"ToAttention"]){ //ToAttention
        AttentionsController *controller=[segue destinationViewController];
        [controller passUserId:[NSString stringWithFormat:@"%@",nowUser.userid]];
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





- (IBAction)logOutBtnClicked:(id)sender {
    
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    [persistentDefaults setObject:nil forKey:@"userName"];
    [persistentDefaults setObject:nil forKey:@"userPassword"];
    [persistentDefaults setObject:nil forKey:@"userGrade"];
    [persistentDefaults setObject:nil forKey:@"userId"];
    [persistentDefaults setObject:nil forKey:@"userHeaderImage"];
    [self.view setNeedsDisplay];
    
    UIView *parent = self.view.superview;
    [self.view removeFromSuperview];
    self.view = nil; // unloads the view
    [parent addSubview:self.view];
    [self.loginBarBtnItem setEnabled:YES];
    
}
@end
