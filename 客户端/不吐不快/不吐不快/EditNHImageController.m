//
//  EditNHImageController.m
//  不吐不快
//
//  Created by WildCat on 13-10-23.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import "EditNHImageController.h"
#import "Reachability.h"
@interface EditNHImageController ()
@property UIImage *uploadImage;
@property NSString *uploadArticle;
@property NSString *uploadImageName;
@property UIImageView *smallimage;
@property NSString *serverUrl;
@end

@implementation EditNHImageController
@synthesize uploadArticle,uploadImage;
@synthesize uploadImageName;
@synthesize _textEditor;
@synthesize smallimage;
@synthesize serverUrl;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //输入框显示区域
    _textEditor = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 280, 100)];
    //设置它的代理
    _textEditor.delegate = self;
    _textEditor.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _textEditor.keyboardType = UIKeyboardTypeDefault;
    _textEditor.font = [UIFont systemFontOfSize:17];
    //_textEditor.text = @"请输入内容";
    
    //默认软键盘是在触摸区域后才会打开
    //这里表示进入当前ViewController直接打开软键盘
    [_textEditor becomeFirstResponder];
    
    //把输入框加在视图中
    [self.view addSubview:_textEditor];
    
    //下方的图片按钮 点击后呼出菜单 打开摄像机 查找本地相册
    UIImage *cameraimage = [UIImage imageNamed:@"123.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(280, 5, 40, 40);
    
    [button setImage:cameraimage forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    
    //把它也加在视图当中
    [self.view addSubview:button];
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    self.serverUrl=[persistentDefaults objectForKey:@"ServerUrl"];
    
}
#pragma mark 打开选项卡
-(void)openMenu
{
    //在这里呼出下方菜单按钮项
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    
    [myActionSheet showInView:self.view];
    
    
}
#pragma mark 点击选择按钮后
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == myActionSheet.cancelButtonIndex)
    {
        [self dismissWithClickedButtonIndex:buttonIndex animated:YES];
       
    }
    
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
            
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }
}
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated{
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
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
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
        // NSLog(@"%@",dateTime);
        self.uploadImageName=[NSString stringWithFormat:@"%@.png",dateTime];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@",self.uploadImageName]] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@/%@",DocumentsPath,  self.uploadImageName];
        
        
        //关闭相册界面
        [picker dismissModalViewControllerAnimated:YES];
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        self.smallimage = [[UIImageView alloc] initWithFrame:
                           CGRectMake(282, 45, 30, 30)] ;
        
        self.smallimage.image = image;
        self.uploadImage=[UIImage imageWithData:data];
        
        //加在视图中
        [self.view addSubview:smallimage];
        
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
        [self setEdgesForExtendedLayout:UIRectEdgeBottom];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)sendInfo
{
    NSLog(@"图片的路径是：%@", filePath);
    
    NSLog(@"您输入框中的内容是：%@", _textEditor.text);
}
#pragma mark 点击上传
- (IBAction)uploadClick:(id)sender {   //点击上传功能
    
   
    
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username=[persistentDefaults objectForKey:@"userName"];
    if ([username length]>0&&username!=nil) {
        if ([self isConnectionAvailable]) {   //检查网络
            if (self.uploadImage!=nil&&[_textEditor.text length]>0) {
                //提交内容到服务器
                
                self.uploadImage=[self reSizeImage:self.uploadImage];
                
                [self uploadNaiHanImageWithUserName:username andArticle:_textEditor.text andImage:self.uploadImage];
            }else{  //验证图片和描述是否为空
                NSString *message=nil;
                if ([_textEditor.text length]<=0) {
                    message=@"你还没吐槽，说点什么吧。";
                }else if(self.uploadImage==nil){
                    message=@"图片不能为空。";
                    
                }
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"警告" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            
        }else{ //网络不可连接
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"警告" message:@"网络不可用，请检查网络连接。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }

    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"警告" message:@"请先登录。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    
    }
          
}
#pragma mark 设置图片大小
- (UIImage *)reSizeImage:(UIImage *)image 

{
    CGFloat pWidth=image.size.width;
    CGFloat pHeight=image.size.height;
    
    CGSize reSize=CGSizeMake(255, (255.f*pHeight)/pWidth);
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}





#pragma mark 上传文件 通过用户名，文章 ，图片名
-(void) uploadNaiHanImageWithUserName:(NSString *) username andArticle:(NSString *) article andImage:(UIImage *)image{
    NSString *imageString=self.uploadImageName;//获得上传文件名
    
    
    
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:[NSString stringWithFormat:@"1.0"] forKey:[NSString stringWithFormat:@"ver"]];
    [_params setObject:[NSString stringWithFormat:@"en"] forKey:[NSString stringWithFormat:@"lan"]];
    [_params setObject:[NSString stringWithFormat:@"%@", username] forKey:[NSString stringWithFormat:@"username"]];   //添加文本值
    [_params setObject:[NSString stringWithFormat:@"%@", article] forKey:[NSString stringWithFormat:@"article"]];   //添加文本值
     [_params setObject:[NSString stringWithFormat:@"%f", image.size.width] forKey:[NSString stringWithFormat:@"imagewidth"]];   //添加文本值
     [_params setObject:[NSString stringWithFormat:@"%f",image.size.height] forKey:[NSString stringWithFormat:@"imageheight"]];   //添加文本值
    
    
    
    
    NSString *BoundaryConstant = [NSString stringWithFormat:@"QPiYnJi19ZBYHjkoKQKagYMKSLsyN5J9"];
    NSURL* requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/myapp/list/",self.serverUrl]];
   
    
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
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; id=\"id_docfile\"; name=\"docfile\"; filename=\"%@\"\r\n",imageString] dataUsingEncoding:NSUTF8StringEncoding]];
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
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"恭喜" message:@"上传成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        self._textEditor.text=@"";
        self.smallimage.image=nil;
        
    }
    
    // NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark  判断网络是佛连接
-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostname:@"http://www.baidu.com"];
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
