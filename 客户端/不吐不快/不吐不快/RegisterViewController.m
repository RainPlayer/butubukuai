//
//  RegisterViewController.m
//  不吐不快
//
//  Created by WildCat on 13-10-13.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterCell.h"
#import "User.h"
#import "Reachability.h"
#define TOPCELLCOLOR [UIColor colorWithRed:245.0/255.0 green:243.0/255.0 blue:241.0/255.0 alpha:1.0]
#define BAGCOLOR [UIColor colorWithRed:245.0/255.0 green:223.0/255.0 blue:181.0/255.0 alpha:1.0]
#define TOPBARCOLOR [UIColor colorWithRed:221/255.0f green:170/255.0f blue:59/255.0f alpha:0]

@interface RegisterViewController ()
@property NSString *serverUrl;
@end

@implementation RegisterViewController
@synthesize serverUrl;
@synthesize nameTextField;
@synthesize passwordTextField;
@synthesize registerBtn;

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
    
    [self.view setBackgroundColor:BAGCOLOR];
    self.registerBtn.backgroundColor=[UIColor colorWithRed:221/255.0f green:170/255.0f blue:59/255.0f alpha:1.0];
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    self.serverUrl=[persistentDefaults objectForKey:@"ServerUrl"];
    
}


- (void)viewDidUnload
{
    
    [self setRegisterBtn:nil];
    [self setNameTextField:nil];
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
- (IBAction)registerBtnClick:(id)sender {
    
    NSString *name=nameTextField.text;
    NSString *password=passwordTextField.text;
    User *user=nil;
    //如果用户名和密码不为空
    if ([name length]>0&&[password length]>0){
        if ([self isConnectionAvailable]) {
            NSString *urlAsString = [NSString stringWithFormat:@"%@/createUser/name=%@&password=%@",self.serverUrl,name,password];
           
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
                    
                    for (id userclassname in deserializedDictionary) {
                        if ([userclassname isEqualToString:@"results"]) {
                            id userElement=[deserializedDictionary objectForKey:userclassname];
                            
                            for (id everyUser in userElement) {//遍历
                                user=[[User alloc] init];
                                for (id detail in everyUser) {
                                    
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
            }
            NSString *message=nil;
            if (user==nil) {
                message=@"昵称已存在！！";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:message
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }else{
               //写入本地配置文件
                NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
                [persistentDefaults setObject:user.name forKey:@"userName"];
                [persistentDefaults setObject:user.password forKey:@"userPassword"];
                [persistentDefaults setObject:user.grade forKey:@"userGrade"];
                [persistentDefaults setObject:user.userid forKey:@"userId"];
                [persistentDefaults setObject:user.headerimage forKey:@"userHeaderImage"];
                [self.navigationController popToRootViewControllerAnimated:YES];

            }
           
        }else{  //网络不可连接
        
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"网络不可用，请检查网络!"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];

        }
        
    }//内容不为空
   
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
