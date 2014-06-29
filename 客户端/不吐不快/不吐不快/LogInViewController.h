//
//  LogInViewController.h
//  不吐不快
//
//  Created by WildCat on 13-10-13.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *toRegisterBtn;

@property (weak, nonatomic) IBOutlet UIButton *logInBtn;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;




- (IBAction)toRegisterClick:(id)sender;

- (IBAction)loginClick:(id)sender;


@end
