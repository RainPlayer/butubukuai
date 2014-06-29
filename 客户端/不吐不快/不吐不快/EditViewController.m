//
//  EditViewController.m
//  不吐不快
//
//  Created by WildCat on 13-10-8.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import "EditViewController.h"
#define BAGCOLOR [UIColor colorWithRed:245.0/255.0 green:223.0/255.0 blue:181.0/255.0 alpha:1.0]
@interface EditViewController ()
@property  UIBarButtonItem * doneButton;
@property bool ifShowCount;// 存储键盘
@property NSString *segueFrom;
@property NSString *serverUrl;
@end

@implementation EditViewController
@synthesize myTextView;
@synthesize doneButton;
@synthesize ifShowCount;
@synthesize segueFrom;
@synthesize serverUrl;
-(void)sendFrom:(NSString *)from{
    self.segueFrom=from;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) viewWillAppear:(BOOL)paramAnimated{
    [super viewWillAppear:paramAnimated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification  object:nil];
    self.myTextView = [[UITextView alloc] initWithFrame:self.view.bounds];
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
    
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myTextView.scrollEnabled=YES;//滚动设置
    self.myTextView.keyboardType=UIKeyboardTypeASCIICapable;  //中文输入
    
    self.myTextView.backgroundColor=BAGCOLOR; //设置背景颜色
//    //
    self.ifShowCount=NO;
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    self.serverUrl=[persistentDefaults objectForKey:@"ServerUrl"];

    
       
}


- (void)viewDidUnload
{
    [self setMyTextView:nil];
    self.serverUrl=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark 监听键盘事件
- (void) handleKeyboardDidShow:(NSNotification *)paramNotification{
    /* Get the frame of the keyboard */
    NSValue *keyboardRectAsObject =
    [[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    /* Place it in a CGRect */
    CGRect keyboardRect;
    [keyboardRectAsObject getValue:&keyboardRect];
    
     /* Give a bottom margin to our text view as much
     as the height of the keyboard */
    self.myTextView.contentInset =UIEdgeInsetsMake(0.0f,
                     0.0f,
                     keyboardRect.size.height,
                     0.0f);
    
    if (self.ifShowCount==NO) {
        self.myTextView.text=@"";
    }
    self.ifShowCount=YES;
    
    
}
- (void) handleKeyboardWillHide:(NSNotification *)paramNotification{
    /* Make the text view as big as the whole view again */
    self.myTextView.contentInset = UIEdgeInsetsZero;
}



#pragma mark 点击提交按钮

- (IBAction)submitBtnClick:(id)sender {
    
   NSString *submitArticel= self.myTextView.text;
    NSString *urlAsString =nil;
    
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId=[persistentDefaults objectForKey:@"userId"];
    
    if (userId!=nil&&[self.myTextView.text length]>0) {
        if ([self.segueFrom isEqualToString:@"Poetry"]) {
            urlAsString = [NSString stringWithFormat:@"%@/createPoetry/userid=%@&poetry=%@",self.serverUrl,userId,submitArticel];
        }else{
            urlAsString = [NSString stringWithFormat:@"%@/createArticle/userid=%@&article=%@",self.serverUrl,userId,submitArticel];
        }
        
        NSString *strURL = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
        [req setHTTPMethod:@"GET"];
        [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        
        
        NSError *error=nil;
        NSData *condata=[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
        if ([condata length] >0 && error == nil){
            
           [self showAlertView:@"提交成功。" andTitle:@"恭喜您"];
            
        }else{
            
            NSLog(@"%@",error);
        }

    }else{
        if ([self.myTextView.text length]<=0) {
            [self showAlertView:@"您还未填写内容。" andTitle:@"友情提示"];
        }else{
            [self showAlertView:@"请先登录。" andTitle:@"友情提示"];
        }
    
    }
    
    
}
#pragma mark 弹出提示框

-(void) showAlertView:(NSString *) message andTitle:(NSString *) title{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];

}

#pragma mark   获得输入框里的值
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"确定"]){
            NSLog(@"OK");
            
        }
    self.myTextView.text=@"";
        
}





@end
