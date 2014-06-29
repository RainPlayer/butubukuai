//
//  FooterTableViewCell.h
//  GodTuCaoDemo1
//
//  Created by WildCat on 13-9-27.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FooterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *badBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@property (weak, nonatomic) IBOutlet UILabel *praisenumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *badnumberLabel;


@end
