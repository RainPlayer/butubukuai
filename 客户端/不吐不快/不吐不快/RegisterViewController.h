//
//  RegisterViewController.h
//  不吐不快
//
//  Created by WildCat on 13-10-13.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

- (IBAction)registerBtnClick:(id)sender;

@end
