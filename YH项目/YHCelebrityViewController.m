//
//  YHCelebrityViewController.m
//  YH项目
//
//  Created by zhujinchi on 16/7/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YHCelebrityViewController.h"
#import "YHCelebrityScrollView.h"
#import "YHCelebrityItem.h"
#import "YHLoginViewController.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <MJExtension/MJExtension.h>

@interface YHCelebrityViewController ()

@property (nonatomic,readonly) CGSize screenSize;
@property (nonatomic,readwrite) UIEdgeInsets edgeInset;
@property (nonatomic,strong) YHCelebrityScrollView *scrollView;
@property (nonatomic, strong) YHCelebrityItem *item;
@property(nonatomic,strong) UIAlertView *alert;


@end

@implementation YHCelebrityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _screenSize = [UIScreen mainScreen].bounds.size;
    self.edgeInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.itemModel.uname;
    [self accessInfo];
    
    // Do any additional setup after loading the view.
}

-(void)accessInfo{
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Celebrity/celebrity";
    NSDictionary *parameters = @{@"cid":_itemModel.uid};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置回复内容信息
    [manager.requestSerializer setValue:YHjwt forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager GET:urlStr
       parameters:parameters//请求参数
          success:^(AFHTTPRequestOperation * operation, id responseObject){
              NSString *html = operation.responseString;
              NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
              id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
              NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
              if ([code isEqualToString:@"200"]) {
                  __weak typeof(self)weakSelf = self;
                  weakSelf.item = [YHCelebrityItem mj_objectWithKeyValues:dict[@"data"][0]];
                  [self setScrollView];
              }else{
                  [self presentAlert:@"数据错误"];
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              [self presentAlert:@"网络错误"];
          }];
}

-(void) setScrollView{
    _scrollView = [[YHCelebrityScrollView alloc] initWithFrame: CGRectMake(0, 0, _screenSize.width, _screenSize.height-64)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.item = _item;
    [_scrollView setContent];
    [self.view addSubview:_scrollView];
}

-(void) presentAlert:(NSString*)content{
    //设置alert时间响应
    _alert=[[UIAlertView alloc]initWithTitle:content message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
    [_alert show];
}

-(void) performDismiss:(NSTimer *)timer
{
    [_alert dismissWithClickedButtonIndex:0 animated:NO];
    //    [_registeralert release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
