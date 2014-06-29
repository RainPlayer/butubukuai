//
//  AddCommentViewController.h
//  不吐不快
//
//  Created by WildCat on 13-10-12.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCommentViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@property NSString *pmd5code;


- (IBAction)submitComment:(id)sender;
#pragma mark  获得PMD5code
-(void)getPmd5code:(NSString *)pmd5code andFrom:(NSString *)from;

@end
