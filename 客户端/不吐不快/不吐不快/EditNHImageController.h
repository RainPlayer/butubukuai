//
//  EditNHImageController.h
//  不吐不快
//
//  Created by WildCat on 13-10-23.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditNHImageController : UIViewController<UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

{
    //输入框
    UITextView *_textEditor;
    //下拉菜单
    UIActionSheet *myActionSheet;
    //图片2进制路径
    NSString* filePath;
}
@property UITextView *_textEditor;
- (IBAction)uploadClick:(id)sender;


@end
