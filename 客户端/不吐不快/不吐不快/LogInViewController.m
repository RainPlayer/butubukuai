//
//  LogInViewController.m
//  不吐不快
//
//  Created by WildCat on 13-10-13.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import "LogInViewController.h"
#import "User.h"
#import "UserViewController.h"
#import "Reachability.h"

#define BAGCOLOR [UIColor colorWithRed:245.0/255.0 green:223.0/255.0 blue:181.0/255.0 alpha:1.0]
#define TOPBARCOLOR [UIColor colorWithRed:221/255.0f green:170/255.0f blue:59/255.0f alpha:0]
@interface LogInViewController ()
@property NSString *serverUrl;
@end

@implementation LogInViewController
@synthesize serverUrl;
@synthesize toRegisterBtn;
@synthesize logInBtn;
@synthesize usernameTextField;
@synthesize passwordTextField;

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
    self.view.backgroundColor=BAGCOLOR;
    self.toRegisterBtn.backgroundColor=[UIColor colorWithRed:221/255.0f green:170/255.0f blue:59/255.0f alpha:0.3];
    self.logInBtn.backgroundColor=[UIColor colorWithRed:221/255.0f green:170/255.0f blue:59/255.0f alpha:1.0];

    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    self.serverUrl=[persistentDefaults objectForKey:@"ServerUrl"];
    
}

- (void)viewDidUnload
{
    [self setToRegisterBtn:nil];
    [self setLogInBtn:nil];
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    self.serverUrl=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark 点击注册按钮
- (IBAction)toRegisterClick:(id)sender {
    
    
}
#pragma mark 点击登陆按钮
- (IBAction)loginClick:(id)sender {
    NSString *username=self.usernameTextField.text;
    NSString *password=self.passwordTextField.text;
    
    if ([username length]>0&&[password length]>0) {
        if ([self isConnectionAvailable]) {
            User *user=nil;
            NSString *urlAsString = [NSString stringWithFormat:@"%@/getUserByName/name=%@",self.serverUrl,username];
            
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
                    for (id userclassname in deserializedDictionary) {
                        if ([userclassname isEqualToString:@"results"]) {   //获得具体内涵段子信息，接着进行解析
                            id userElement=[deserializedDictionary objectForKey:userclassname];
                            for (id everyUser in userElement) {//遍历每一篇内涵段子
                                user=[[User alloc] init];
                                for (id detail in everyUser) {                      //获得每篇文章的内容
                                    
                                    id ele=[everyUser objectForKey:detail];
                                    if ([detail isEqualToString:@"name"]) {
                                        user.name=ele;
                                    }else if ([detail isEqualToString:@"password"]){
                                        user.password=ele;
                                    }else if ([detail isEqualToString:@"id"]){
                                        user.userid=ele;
                                    }else if ([detail isEqualToString:@"grade"]){
                                        user.grade=ele;
                                    }else if ([detail isEqualToString:@"headerimage"]){
                                        user.headerimage=ele;
                                    }
                                    
                                }
                            }//end 遍历每一篇内涵段子
                            
                        }
                    }//end for
                }
                
                
            }else{
                NSLog(@"%@",error);
            }
            
            
            //如果user为空，弹出对话框显示用户名密码错误，否则跳转到成功页面
            if (user==nil) {
                [self alertViewShowMessage:@"用户名或密码错误。"];
            }else{
                if ([user.password isEqualToString:password]) {
                    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
                    [persistentDefaults setObject:user.name forKey:@"userName"];
                    [persistentDefaults setObject:user.password forKey:@"userPassword"];
                    [persistentDefaults setObject:user.grade forKey:@"userGrade"];
                    [persistentDefaults setObject:user.userid forKey:@"userId"];
                    [persistentDefaults setObject:user.headerimage forKey:@"userHeaderImage"];
                    //跳转到个人主页
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self alertViewShowMessage:@"密码错误"];
                
                }
               
                
            }

        }else{ //网络可以连接
            [self alertViewShowMessage:@"请检查网络。"];
        }
    }
    
    
}

-(void) alertViewShowMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];


}


#pragma mark 键盘添加隐藏按钮
- (void) viewWillAppear:(BOOL)paramAnimated{
    [super viewWillAppear:paramAnimated];
      
    
    //添加键盘菜单
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonSystemItemCancel target:self action:@selector(dismissKeyBoard)];
    
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    
    [topView setItems:buttonsArray];
    
    [self.passwordTextField setInputAccessoryView:topView];
    [self.usernameTextField setInputAccessoryView:topView];
    
    
}
//隐藏键盘
-(void) dismissKeyBoard {
    
    [self.passwordTextField resignFirstResponder];
    [self.usernameTextField resignFirstResponder];
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



