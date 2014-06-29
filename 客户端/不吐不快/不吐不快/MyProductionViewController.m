//
//  MyProductionViewController.m
//  不吐不快
//
//  Created by WildCat on 13-10-29.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import "MyProductionViewController.h"
#import "NeiHanImageClass.h"
#import "HeaderTableCell.h"
#import "FooterTableViewCell.h"
#import "NeiHanImageCell.h"
#import "Reachability.h"
#import "CommentViewController.h"
#import "EditViewController.h"
#import "DuanZi.h"
#import "TextMidCell.h"
#define TOPCELLCOLOR [UIColor colorWithRed:245.0/255.0 green:243.0/255.0 blue:241.0/255.0 alpha:1.0]
#define BAGCOLOR [UIColor colorWithRed:245.0/255.0 green:223.0/255.0 blue:181.0/255.0 alpha:1.0]

#define FONT_SIZE 16.0f
#define CELL_CONTENT_WIDTH 305.0f
#define CELL_CONTENT_MARGIN 10.0f
#define IMAGEHEIGHT 100.0f
@interface MyProductionViewController ()
@property NSMutableArray *itemArray;
@property NSString *serverUrl;
@end

@implementation MyProductionViewController
@synthesize myArray;
@synthesize itemArray;
@synthesize userInfo;
@synthesize serverUrl;
-(void)passUserInfo:(User *)passUserInfo{
    self.userInfo=passUserInfo;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundColor:BAGCOLOR];
     self.myArray=nil;
    //设置header of grouped section
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 10.f)];

    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    self.serverUrl=[persistentDefaults objectForKey:@"ServerUrl"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self parserNeiHanImage];
        [self parserDuanZi:@"NeiHanArticles"];
        [self parserDuanZi:@"Poetrys"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
    });
    
    
}
#pragma mark - 解析
#pragma mark 解析内涵段子具体信息
-(void) parserNeiHanImage
{
    
    if (self.itemArray==nil) {
        self.itemArray=[NSMutableArray array];
    }
    
    //获得json数据
    
    NSString *urlAsString = [NSString stringWithFormat:@"%@/getNHImageByUserId/username=%@&userid=%@",self.serverUrl,self.userInfo.name,self.userInfo.userid];
    NSString *strURL = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"]; //以get方式请求
    NSError *error=nil;
    NSData *condata=[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    
    if ([condata length] >0 && error == nil){
        id jsonObject2 = [NSJSONSerialization
                          JSONObjectWithData:condata
                          options:NSJSONReadingAllowFragments
                          error:&error];
        if (jsonObject2 != nil&& error == nil){
            
            NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject2;
            //遍历数据源获得新闻
            
            
            for (id articleclassname in deserializedDictionary) {
                
                
                if ([articleclassname isEqualToString:@"results"]) {   //获得具体内涵段子信息，接着进行解析
                    id articleElement=[deserializedDictionary objectForKey:articleclassname];
                    NeiHanImageClass *neiHanImageClass=nil;
                    
                    for (id everyArticel in articleElement) {//遍历每一篇内涵段子
                        neiHanImageClass=[[NeiHanImageClass alloc] init];
                        for (id detail in everyArticel) {                      //获得每篇文章的内容
                            
                            id ele=[everyArticel objectForKey:detail];
                            if ([detail isEqualToString:@"article"]) {
                                neiHanImageClass.article=ele;
                            }else if ([detail isEqualToString:@"date"]){
                                neiHanImageClass.date=ele;
                            }else if ([detail isEqualToString:@"id"]){
                                neiHanImageClass.idnumber=ele;
                            }else if ([detail isEqualToString:@"praisenumber"]){
                                neiHanImageClass.praisenumber=ele;
                            }else if ([detail isEqualToString:@"badnumber"]){
                                neiHanImageClass.badnumber=ele;
                            }else if ([detail isEqualToString:@"username"]){
                                neiHanImageClass.username=ele;
                               
                                                                
                            }else if ([detail isEqualToString:@"docfile"]){
                                neiHanImageClass.imageUrl=[NSString stringWithFormat:@"%@/media/%@",self.serverUrl,ele];
                            }else if ([detail isEqualToString:@"imagewidth"]){
                                neiHanImageClass.imagewidth=ele;
                            }else if ([detail isEqualToString:@"imageheight"]){
                                neiHanImageClass.imageHeight=ele;
                            }
                            
                        }
                        [itemArray insertObject:neiHanImageClass atIndex:0];
                        
                    }//end 遍历每一篇内涵段子
                    
                }                
            }//end for
        }
    }
    
    self.myArray=itemArray;
    
}

#pragma mark 解析内涵段子具体信息
-(void) parserDuanZi:(NSString *)type
{
    
    if (self.itemArray==nil) {
        self.itemArray=[NSMutableArray array];
    }
    
    //获得json数据
    //???????
    NSString *urlAsString = [NSString stringWithFormat:@"%@/get%@ByUserId/username=%@&userid=%@",self.serverUrl,type,self.userInfo.name,self.userInfo.userid];
    NSString *strURL = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strURL];    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"]; //以get方式请求
    NSError *error=nil;
    NSData *condata=[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    
    if ([condata length] >0 && error == nil){
        id jsonObject2 = [NSJSONSerialization
                          JSONObjectWithData:condata
                          options:NSJSONReadingAllowFragments
                          error:&error];
        if (jsonObject2 != nil&& error == nil){
            
            NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject2;
            //遍历数据源获得新闻
            
            
            for (id articleclassname in deserializedDictionary) {
                
                
                if ([articleclassname isEqualToString:@"results"]) {   //获得具体内涵段子信息，接着进行解析
                    id articleElement=[deserializedDictionary objectForKey:articleclassname];
                    DuanZi *duanZi=nil;
                    
                    for (id everyArticel in articleElement) {//遍历每一篇内涵段子
                        duanZi=[[DuanZi alloc] init];
                        for (id detail in everyArticel) {                      //获得每篇文章的内容
                            
                            id ele=[everyArticel objectForKey:detail];
                            if ([detail isEqualToString:@"article"]) {
                                duanZi.article=ele;
                                duanZi.type=type;
                            }else if ([detail isEqualToString:@"userid"]){
                                duanZi.userid=ele;
                            }else if ([detail isEqualToString:@"date"]){
                                duanZi.date=ele;
                            }else if ([detail isEqualToString:@"md5code"]){
                                duanZi.md5code=ele;
                            }else if ([detail isEqualToString:@"id"]){
                                duanZi.idnumber=ele;
                            }else if ([detail isEqualToString:@"praisenumber"]){
                                duanZi.praisenumber=ele;
                            }else if ([detail isEqualToString:@"badnumber"]){
                                duanZi.badnumber=ele;
                            }
                            
                        }
                        [itemArray insertObject:duanZi atIndex:0];
                        
                    }//end 遍历每一篇内涵段子
                    
                }                
            }//end for
        }
        
        
    }
    
    self.myArray=itemArray;
    
    
}


#pragma mark 注销
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.itemArray=nil;
    self.myArray=nil;
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=0.f;
    NeiHanImageClass *nowNHImageClass=nil;
    DuanZi *nowDuanZi=nil;
    NSString *text =nil;
    if ([[self.myArray objectAtIndex:indexPath.section] isKindOfClass:[NeiHanImageClass class]]) {
        nowNHImageClass=[self.myArray objectAtIndex:indexPath.section];
        text= nowNHImageClass.article;
        
        if (indexPath.row%3==1) {
            
            
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            CGFloat height = MAX(size.height, 44.0f);
            
            return height + (CELL_CONTENT_MARGIN * 2)+[nowNHImageClass.imageHeight floatValue];
        }else {
            height=37.f;
        }
    }else{
        nowDuanZi=[self.myArray objectAtIndex:indexPath.section];
        text= nowDuanZi.article;
        if (indexPath.row%3==1) {
            
            
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            CGFloat height = MAX(size.height, 44.0f);
            
            return height + (CELL_CONTENT_MARGIN * 2);
        }else {
            height=37.f;
        }
    }
    
        
    
    return height;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.myArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    
}
#pragma mark 添加Cell的具体内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HeaderTableCell";
    static NSString *MidCellIdentifier = @"NeiHanImageCell";
    static NSString *TextMidCellIdentifier = @"TextMidCell";
    static NSString *FootCellIdentifier = @"FootCell";
    TextMidCell *textMidCell= [tableView dequeueReusableCellWithIdentifier:TextMidCellIdentifier];
    HeaderTableCell *headerCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NeiHanImageCell *middleCell=[tableView dequeueReusableCellWithIdentifier:MidCellIdentifier];
    FooterTableViewCell *footCell=[tableView dequeueReusableCellWithIdentifier:FootCellIdentifier];
    NeiHanImageClass *nowNHImageClass=nil;
    DuanZi *nowDuanZi=nil;
    NSString *praisenumber=nil;
    NSString *badnumber=nil;
    if ([[self.myArray objectAtIndex:indexPath.section] isKindOfClass:[NeiHanImageClass class]]) {
        
        nowNHImageClass=[self.myArray objectAtIndex:indexPath.section];
        praisenumber=[nowNHImageClass.praisenumber stringValue];
        badnumber=[nowNHImageClass.badnumber stringValue];
    }else{
        nowDuanZi=[self.myArray objectAtIndex:indexPath.section];
        praisenumber=[nowDuanZi.praisenumber stringValue];
        badnumber=[nowDuanZi.badnumber stringValue];
    }
   
    
    
    
    if (indexPath.row%3==0) {
        if (headerCell==nil) {
            headerCell=[[HeaderTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        headerCell.timerLabel.text=nowNHImageClass.date;
        if ([self.userInfo.headerimage length]>0) {
            [headerCell setUrlByString:[NSString stringWithFormat:@"%@/media/%@",self.serverUrl,self.userInfo.headerimage]];
        }
       
        headerCell.nameLabel.text=self.userInfo.name;
        UIView *sectionBagView=[[UIView alloc] initWithFrame:headerCell.bounds] ;
        headerCell.backgroundView=sectionBagView;
        headerCell.backgroundView.backgroundColor=TOPCELLCOLOR;
        
        
        return headerCell;
    }else if(indexPath.row%3==1) {
        UILabel *label = nil;
        
        if ([[self.myArray objectAtIndex:indexPath.section] isKindOfClass:[NeiHanImageClass class]]) {
            if (middleCell==nil) {
                middleCell=[[NeiHanImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MidCellIdentifier];
                
                label = [[UILabel alloc] initWithFrame:CGRectZero];
                [label setLineBreakMode:UILineBreakModeWordWrap];
                [label setMinimumFontSize:FONT_SIZE];
                [label setNumberOfLines:0];
                [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
                // middleCell.titleLabel=label;
                [[middleCell contentView] addSubview:label];//label 显示出来，如果用上边的则显示不出来
            }
            
            
            [middleCell setUrlByString:nowNHImageClass.imageUrl];
            
            //设置背景颜色
            UIView *sectionBagView=[[UIView alloc] initWithFrame:middleCell.bounds] ;
            middleCell.backgroundView=sectionBagView;
            middleCell.backgroundView.backgroundColor=[UIColor whiteColor];
            
            NSString *text =nowNHImageClass.article;
            //设置字体高度
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            if (! middleCell.titleLabel){
                
                middleCell.titleLabel = (UILabel*)[middleCell viewWithTag:1];
            }
            
            [middleCell setTitleLabelText:text];
            
            [middleCell.titleLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];  //设置label的fram
            //下面设置ImageView的显示，图片宽度设置为255，高度为按比例缩放。
            [middleCell setBtbkImageViewFram:CGRectMake(CELL_CONTENT_MARGIN+12, MAX(size.height, 44.0f)+20, 255, (255*[nowNHImageClass.imageHeight floatValue])/[nowNHImageClass.imagewidth floatValue])];//设置图片的frame
            
            //设置选中后的背景颜色
            middleCell.selectedBackgroundView=[[UIView alloc]initWithFrame:middleCell.frame];
            middleCell.selectedBackgroundView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:231.0/255.0 blue:221.0/255.0 alpha:1.0];
            
            
            return middleCell;
        }else{
            if (textMidCell==nil) {
                textMidCell = [[TextMidCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MidCellIdentifier] ;
                
                label = [[UILabel alloc] initWithFrame:CGRectZero];
                [label setLineBreakMode:UILineBreakModeWordWrap];
                [label setMinimumFontSize:FONT_SIZE];
                [label setNumberOfLines:0];
                [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
                textMidCell.myTextLabel=label;
                
            }
            
            //设置背景颜色
            UIView *sectionBagView=[[UIView alloc] initWithFrame:textMidCell.bounds] ;
            textMidCell.backgroundView=sectionBagView;
            textMidCell.backgroundView.backgroundColor=[UIColor whiteColor];
            
            NSString *text = nowDuanZi.article;
            //设置字体高度
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            if (! textMidCell.myTextLabel)
                textMidCell.myTextLabel = (UILabel*)[textMidCell viewWithTag:1];
            
            [textMidCell.myTextLabel setText:text];
            
            [textMidCell.myTextLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];  //设置label的fram
            
            
            
            //设置选中后的背景颜色
            
            textMidCell.selectedBackgroundView=[[UIView alloc]initWithFrame:textMidCell.frame];
            textMidCell.selectedBackgroundView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:231.0/255.0 blue:221.0/255.0 alpha:1.0];
            
            return textMidCell;
        
        
        }
        
       
        
    }else if(indexPath.row%3==2){
        if (footCell==nil) {
            footCell=[[FooterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FootCellIdentifier];
        }
        
        // footCell.commentBtn.titleLabel.text=@"32";
        UIView *sectionBagView=[[UIView alloc] initWithFrame:footCell.bounds] ;
        footCell.backgroundView=sectionBagView;
        footCell.backgroundView.backgroundColor=[UIColor whiteColor];
        
        footCell.praisenumberLabel.text=[NSString stringWithFormat:@"%@",praisenumber];
        footCell.badnumberLabel.text=[NSString stringWithFormat:@"%@",badnumber];
        
        
        
        return footCell;
    }
    
    return headerCell;
}
#pragma mark prepareForSegue 进行页面传值
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    UIViewController *controller;
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        controller = [navController.viewControllers objectAtIndex:0];
    } else {
        controller = segue.destinationViewController;
    }
    NSIndexPath *selectIndexPath= [self.tableView indexPathForSelectedRow];
        
    NeiHanImageClass *nowNHImageClass=nil;
    DuanZi *nowDuanZi=nil;
  
    if ([[self.myArray objectAtIndex:selectIndexPath .section] isKindOfClass:[NeiHanImageClass class]]) {
        
        nowNHImageClass=[self.myArray objectAtIndex:selectIndexPath .section];
      
    }else{
        nowDuanZi=[self.myArray objectAtIndex:selectIndexPath .section];
    }
    
    
    //DuanZiSegue
    if([[segue identifier] isEqualToString:@"commentsegue"]){
        
        if ([controller isKindOfClass:[CommentViewController class]]) {
            CommentViewController *commentViewController = (CommentViewController *)controller;
            
            [commentViewController getPmd5code:[NSString stringWithFormat:@"%@",nowNHImageClass.idnumber] andFrom:@"nhimage"];
        } 
    } else if([[segue identifier] isEqualToString:@"DuanZiSegue"]){
       
        if ([controller isKindOfClass:[CommentViewController class]]) {
            CommentViewController *commentViewController = (CommentViewController *)controller;
            
            if ([nowDuanZi.type isEqualToString:@"Poetrys"]) {
                
                 [commentViewController getPmd5code:[NSString stringWithFormat:@"%@",nowDuanZi.md5code] andFrom:@"poetry"];
            }else{
                
                [commentViewController getPmd5code:[NSString stringWithFormat:@"%@",nowDuanZi.md5code] andFrom:@"DuanZi"];
            }
           
        }
    }
    
}


#pragma mark - Table view delegate
#pragma mark 点击Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
