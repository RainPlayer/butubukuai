//
//  EditViewController.h
//  不吐不快

//内涵段子，古诗新对，添加内容


//
//  Created by WildCat on 13-10-8.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController<UITextViewDelegate>


@property (strong, nonatomic) IBOutlet UITextView *myTextView;

- (IBAction)submitBtnClick:(id)sender;
-(void)sendFrom:(NSString *) from;
@end
