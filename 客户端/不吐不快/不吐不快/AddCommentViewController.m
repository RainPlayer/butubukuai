//
//  AddCommentViewController.m
//  不吐不快
//
//  Created by WildCat on 13-10-12.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import "AddCommentViewController.h"
#import "Reachability.h"
#define BAGCOLOR [UIColor colorWithRed:245.0/255.0 green:223.0/255.0 blue:181.0/255.0 alpha:1.0]
@interface AddCommentViewController ()
@property  UIBarButtonItem * doneButton;
@property int showCount;
@property NSString *paramFrom;
@property NSString *serverUrl;
@end

@implementation AddCommentViewController
@synthesize myTextView;
@synthesize doneButton;
@synthesize showCount;
@synthesize paramFrom;
@synthesize serverUrl;
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
	self.myTextView.scrollEnabled=YES;//滚动设置
    self.myTextView.backgroundColor=BAGCOLOR; //设置背景颜色
    self.showCount=0;
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    self.serverUrl=[persistentDefaults objectForKey:@"ServerUrl"];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.serverUrl=nil;
    self.myTextView=nil;
    self.doneButton=nil;
    self.showCount=nil;
    self.paramFrom=nil;
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 控制键盘
- (void) handleKeyboardDidShow:(NSNotification *)paramNotification{
    /* Get the frame of the keyboard */
    NSValue *keyboardRectAsObject =[[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    /* Place it in a CGRect */
    CGRect keyboardRect;
    [keyboardRectAsObject getValue:&keyboardRect];
    
     /* Give a bottom margin to our text view as much
     as the height of the keyboard */
    self.myTextView.contentInset =UIEdgeInsetsMake(0.0f,
                     0.0f,
                     keyboardRect.size.height,
                     0.0f);
    self.showCount++;
    if (self.showCount==1) {
        self.myTextView.text=@"";
    }
    
}

- (void) handleKeyboardWillHide:(NSNotification *)paramNotification{
    /* Make the text view as big as the whole view again */
    self.myTextView.contentInset = UIEdgeInsetsZero;
}

- (void) viewWillAppear:(BOOL)paramAnimated{
    [super viewWillAppear:paramAnimated];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidShow:)
                                                name:UIKeyboardDidShowNotification
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardWillHide:)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];
    
    
    self.myTextView.text = @"银不吐槽枉骚年。。。";
    self.myTextView.font = [UIFont systemFontOfSize:16.0f];
    self.myTextView.backgroundColor=BAGCOLOR;
    [self.view addSubview:self.myTextView];
    
    //添加键盘菜单
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    self.doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonSystemItemCancel target:self action:@selector(dismissKeyBoard)];
    
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    
    [topView setItems:buttonsArray];
    
    [self.myTextView setInputAccessoryView:topView];
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])  //调整ios7的UIItembar
        [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
}
//隐藏键盘
-(void) dismissKeyBoard {
    
    [myTextView resignFirstResponder];
}
- (void) viewWillDisappear:(BOOL)paramAnimated{
    [super viewWillDisappear:paramAnimated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 点击提交按钮
- (IBAction)submitComment:(id)sender {
    NSString *submitComment= self.myTextView.text;
    NSString *urlAsString =nil;
    
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username=[persistentDefaults objectForKey:@"userName"];
    if ([self isConnectionAvailable]&&[self.myTextView.text length]>0) {
        if ([username length]>0&&username!=nil) {
            if ([self.paramFrom isEqualToString:@"poetry"]) {
                urlAsString = [NSString stringWithFormat:@"%@/insertPoetryComment/Pmd5code=%@&observer=%@&discuss=%@",self.serverUrl,self.pmd5code,username,submitComment];
            }else if([self.paramFrom isEqualToString:@"nhimage"]){
                urlAsString = [NSString stringWithFormat:@"%@/myapp/insertNHImageComment/pid=%@&observer=%@&discuss=%@",self.serverUrl,self.pmd5code,username,submitComment];
            }else{
                urlAsString = [NSString stringWithFormat:@"%@/insertNHArtComment/Pmd5code=%@&observer=%@&discuss=%@",self.serverUrl,self.pmd5code,username,submitComment];
            }
             NSLog(@"-------->comment:%@",urlAsString);
            
            NSString *strURL = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            // requesting weather for this location ...
            NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
            [req setHTTPMethod:@"GET"];
            [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
                        
            NSError *error=nil;
            NSData *condata=[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
            if ([condata length] >0 && error == nil){
                [self alertViewShowMessage:@"评论提交成功" andTitle:@"恭喜你"];
            }else{
                
                NSLog(@"%@",error);
            }
            
        }else{
            [self alertViewShowMessage:@"对不起，你还没有登陆。" andTitle:@"友情提示"];
        }

    }else{
        if ([self.myTextView.text length]<=0) {
            [self alertViewShowMessage:@"您还未填写内容。" andTitle:@"友情提示"];
        }else{
        
        [self alertViewShowMessage:@"请检查网络连接" andTitle:@"友情提示"];
        }
    }
}

#pragma mark 弹出窗口
-(void) alertViewShowMessage:(NSString *)message andTitle:(NSString *) title{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];

}


#pragma mark  获得PMD5code
-(void)getPmd5code:(NSString *)pmd5code andFrom:(NSString *)from{
    self.pmd5code=pmd5code;
    self.paramFrom=from;
    
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
