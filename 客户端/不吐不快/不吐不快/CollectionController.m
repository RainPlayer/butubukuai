//
//  CollectionController.m
//  不吐不快
//
//  Created by WildCat on 13-10-28.
//  Copyright (c) 2013年 wildcat. All rights reserved.
//

#import "CollectionController.h"
#import "Collection.h"
#import "TextMidCell.h"
#import "NeiHanImageCell.h"
#import "CommentViewController.h"
#import "User.h"
#define TOPCELLCOLOR [UIColor colorWithRed:245.0/255.0 green:243.0/255.0 blue:241.0/255.0 alpha:1.0]
#define BAGCOLOR [UIColor colorWithRed:245.0/255.0 green:223.0/255.0 blue:181.0/255.0 alpha:1.0]

#define FONT_SIZE 16.0f
#define CELL_CONTENT_WIDTH 305.0f
#define CELL_CONTENT_MARGIN 10.0f
#define IMAGEHEIGHT 100.0f
@interface CollectionController ()
@property NSString *serverUrl;
@end

@implementation CollectionController
@synthesize myArray;
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
    self.myArray=[NSMutableArray array];
    
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    self.serverUrl=[persistentDefaults objectForKey:@"ServerUrl"];
    
    
    
    [self.tableView setBackgroundColor:BAGCOLOR];
    //设置header of grouped section
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 10.f)];
    //异步加载收藏数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getCollections];  //获得收藏内容
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
    });


}

- (void)viewDidUnload
{
    self.myArray=nil;
    self.userInfo=nil;
    self.serverUrl=nil;
    [super viewDidUnload];
}

#pragma mark 获得所有收藏
-(void) getCollections{
  
    NSString *collectionUrl=[NSString stringWithFormat:@"%@/getCollectionsByName/collector=%@/?page_size=5000",self.serverUrl,self.userInfo.name];
    NSString *strURL = [collectionUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
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
            
            for (id articleclassname in deserializedDictionary) {
                
                
                if ([articleclassname isEqualToString:@"results"]) {   
                    id articleElement=[deserializedDictionary objectForKey:articleclassname];
                    Collection *collection=nil;
                    
                    for (id everyArticel in articleElement) {//
                        collection=[[Collection alloc] init];
                        for (id detail in everyArticel) {         //获得每
                            
                            id ele=[everyArticel objectForKey:detail];
                            if ([detail isEqualToString:@"id"]) {
                                collection.idcount=ele;
                            }else if ([detail isEqualToString:@"collector"]){
                                collection.collector=ele;
                            }else if ([detail isEqualToString:@"collectiontype"]){
                                collection.collectionType=ele;
                            }else if ([detail isEqualToString:@"pmd5code"]){
                                collection.pmd5code=ele;
                            }else if ([detail isEqualToString:@"pid"]){
                                collection.pid=ele;
                            }else if ([detail isEqualToString:@"imageurl"]){
                                collection.imageUrl=ele;
                            }else if ([detail isEqualToString:@"content"]){
                                collection.content=ele;
                            }
                            
                        }
                        [self.myArray addObject:collection];
                        
                    }//end 遍历每一篇内涵段子
                    
                }
            }//end for
        }        
    }

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return self.myArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TextIdentifier = @"TextIdentifier";
    static NSString *ImageIdentifier = @"ImageIdentifier";
    
    TextMidCell *textMidCell=[tableView dequeueReusableCellWithIdentifier:TextIdentifier];
    NeiHanImageCell *neiHanImageCell=[tableView dequeueReusableCellWithIdentifier:ImageIdentifier];
    
    UILabel *label = nil;
    
     Collection *nowCollection=[self.myArray objectAtIndex:indexPath.section];
    
    if ([nowCollection.collectionType isEqualToString:@"poetry"]||[nowCollection.collectionType isEqualToString:@"duanzi"]) {  //如果不是图片
        if (textMidCell==nil) {
            textMidCell=[[TextMidCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextIdentifier];
            
            label = [[UILabel alloc] initWithFrame:CGRectZero];
            [label setLineBreakMode:UILineBreakModeWordWrap];
            [label setMinimumFontSize:FONT_SIZE];
            [label setNumberOfLines:0];
            [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
            
            [[textMidCell contentView] addSubview:label];//label 显示出来，如果用上边的则显示不出来
            
        }
        //设置背景颜色
        UIView *sectionBagView=[[UIView alloc] initWithFrame:textMidCell.bounds] ;
        textMidCell.backgroundView=sectionBagView;
        textMidCell.backgroundView.backgroundColor=[UIColor whiteColor];
        
        //NSString *text = [self.myArray objectAtIndex:indexPath.section];
        //设置字体高度
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        CGSize size = [nowCollection.content sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        if (! textMidCell.myTextLabel)
            textMidCell.myTextLabel = (UILabel*)[textMidCell viewWithTag:1];
        
        [textMidCell.myTextLabel setText:nowCollection.content];
        
        [textMidCell.myTextLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];  //设置label的fram
        
        
        
        //设置选中后的背景颜色
        
        textMidCell.selectedBackgroundView=[[UIView alloc]initWithFrame:textMidCell.frame];
        textMidCell.selectedBackgroundView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:231.0/255.0 blue:221.0/255.0 alpha:1.0];
        
        return textMidCell;
    }else if([nowCollection.collectionType isEqualToString:@"nhimage"]){   //如果是内涵图片
       
        if (neiHanImageCell==nil) {
            neiHanImageCell=[[NeiHanImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ImageIdentifier];
            
            label = [[UILabel alloc] initWithFrame:CGRectZero];
            [label setLineBreakMode:UILineBreakModeWordWrap];
            [label setMinimumFontSize:FONT_SIZE];
            [label setNumberOfLines:0];
            [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
            
            [[neiHanImageCell contentView] addSubview:label];//label 显示出来，如果用上边的则显示不出来
        }
        
        
        [neiHanImageCell setUrlByString:[NSString stringWithFormat:@"%@/media/%@",self.serverUrl,nowCollection.imageUrl]];
        
        //设置背景颜色
        UIView *sectionBagView=[[UIView alloc] initWithFrame:neiHanImageCell.bounds] ;
        neiHanImageCell.backgroundView=sectionBagView;
        neiHanImageCell.backgroundView.backgroundColor=[UIColor whiteColor];
        
        NSString *text =nowCollection.content;
        //设置字体高度
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        if (! neiHanImageCell.titleLabel){
            
            neiHanImageCell.titleLabel = (UILabel*)[neiHanImageCell viewWithTag:1];
        }
        
        [neiHanImageCell setTitleLabelText:text];
        
        [neiHanImageCell.titleLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];  //设置label的fram
        //下面设置ImageView的显示，图片宽度设置为255，高度为按比例缩放。
        [neiHanImageCell setBtbkImageViewFram:CGRectMake(CELL_CONTENT_MARGIN+12, MAX(size.height, 44.0f)+20, 255, 100)];//设置图片的frame
        
        //设置选中后的背景颜色
        neiHanImageCell.selectedBackgroundView=[[UIView alloc]initWithFrame:neiHanImageCell.frame];
        neiHanImageCell.selectedBackgroundView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:231.0/255.0 blue:221.0/255.0 alpha:1.0];
        
        
        return neiHanImageCell;
    }
    
    return textMidCell;
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=0.f;
    Collection *nowcollection=[self.myArray objectAtIndex:indexPath.section];
    
    
    
    if ([nowcollection.collectionType isEqualToString:@"nhimage"]) {
        NSString *text = nowcollection.content;
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat height = MAX(size.height, 44.0f);
        
        return height + (CELL_CONTENT_MARGIN * 2)+105;//暂时以100代替图片高度
    }else{
        NSString *text = nowcollection.content;
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat height = MAX(size.height, 44.0f);
        
        return height + (CELL_CONTENT_MARGIN * 2);
    }
    return height;
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *controller;
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        controller = [navController.viewControllers objectAtIndex:0];
    } else {
        controller = segue.destinationViewController;
    }
    
    
    NSIndexPath *selectIndexPath = [self.tableView indexPathForSelectedRow];
    
    Collection *collection=[self.myArray objectAtIndex:selectIndexPath.section];
        
    
    if([[segue identifier] isEqualToString:@"commentsegue"]){
        
        if ([controller isKindOfClass:[CommentViewController class]]) {
            CommentViewController *commentViewController = (CommentViewController *)controller;
            NSString *type=collection.collectionType;
            if ([type isEqualToString:@"poetry"]) {
                 [commentViewController getPmd5code:collection.pmd5code andFrom:@"poetry"];
            }else if([type isEqualToString:@"nhimage"]){
                [commentViewController getPmd5code:[NSString stringWithFormat:@"%@",collection.pid] andFrom:@"nhimage"];
            }else{
                 [commentViewController getPmd5code:collection.pmd5code andFrom:@"duanzi"];
            }
            
        } else {
            NSAssert(NO, @"Unknown segue. All segues must be handled.");
        }//ToAddContent
    }


}
@end
