//
//  SearchViewController.m
//  JH项目
//
//  Created by Zero on 16/1/28.
//  Copyright (c) 2016年 Apple. All rights reserved.
//

#import "YHSearchViewController.h"
#import "YHSearchBar.h"
#import "YHMatchResultViewController.h"
#import "YHCelebrityResultViewController.h"
#import "YHDataView.h"
#import "YHSearchResultViewController.h"
#import "YHSearchScrollView.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <MJExtension/MJExtension.h>
#import "YHInfoPopViewItems.h"
#import "YHLoginViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "YHintroductionViewController.h"

@interface YHSearchViewController ()<YHSearchScrollViewTouchHandler,YHSearchBarTouchHandler>

@property(nonatomic,readonly)CGSize screenSize;
@property(nonatomic,strong) YHInfoPopViewItems *items;
@property(nonatomic,strong)YHSearchScrollView *scrollView;
@property(nonatomic,strong)YHSearchBar *searchBar;
@property(nonatomic,strong)UIView *glassView;
@property(nonatomic,strong) UIAlertView *textalert;

@end

@implementation YHSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _screenSize = [UIScreen mainScreen].bounds.size;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1]];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title = @"匹配";
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self createUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self accessInfo];
}

-(void) createUI{
    YHSearchBar *searchBar = [[YHSearchBar alloc] initWithFrame:CGRectMake(0, 0, _screenSize.width, 44)WithType:YES];
    _searchBar = searchBar;
    _searchBar.searchBarTouchHandlerDelegate = self;
    [self.view addSubview:_searchBar];
    
    _glassView = [[UIView alloc] initWithFrame:CGRectMake(0, _searchBar.frame.size.height, _screenSize.width, _screenSize.height-_searchBar.frame.size.height-44-64)];
    _glassView.backgroundColor = [UIColor blackColor];
    _glassView.alpha = 0.4;

    _scrollView = [[YHSearchScrollView alloc] initWithFrame:CGRectMake(0,_searchBar.frame.size.height, _screenSize.width, _glassView.frame.size.height)];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self accessInfo];
    }];
    _scrollView.mj_header = header;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.searchScrollViewTouchHandlerDelegate = self;
    [self.view addSubview:_scrollView];
    //
}

#pragma mark - self

-(void)keyboardHide{
    [self.searchBar.searchTextField resignFirstResponder];
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(void) searchWith:(NSString *)string{
    YHSearchResultViewController *searchResult = [[YHSearchResultViewController alloc] init];
    searchResult.string = string;
    searchResult.hidesBottomBarWhenPushed = YES;
    searchResult.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:searchResult animated:YES];
}

-(void) endRefresh{
    if ([_scrollView.mj_header isRefreshing]) {
        [_scrollView.mj_header endRefreshing];
    }
}

-(void) accessInfo{
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Feature/feature";
    NSDictionary *parameters = @{@"type":@"1",@"uid":YHuid,@"muid":YHuid};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置回复内容信息
    [manager.requestSerializer setValue:YHjwt forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:urlStr
       parameters:parameters//请求参数
          success:^(AFHTTPRequestOperation * operation, id responseObject){
              NSString *html = operation.responseString;
              NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
              id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
              NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
              if ([code isEqualToString:@"200"]) {
                  __weak typeof(self)weakSelf = self;
                  weakSelf.items = [YHInfoPopViewItems mj_objectWithKeyValues:dict[@"data"]];
                  [_scrollView setItems:_items];
              }else{
                  [self presentAlert:@"数据错误"];
              }
              [self endRefresh];
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              [self presentAlert:@"网络错误"];
              [self endRefresh];
          }];
}

-(void) presentAlert:(NSString*)content{
    //设置alert时间响应
    _textalert = [[UIAlertView alloc]initWithTitle:content message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
    [_textalert show];
}

-(void) performDismiss:(NSTimer *)timer
{
    [_textalert dismissWithClickedButtonIndex:0 animated:NO];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SearchBarTouchHandler

-(void) buttonTapWith:(NSString *)string{
    if (![self isBlankString:string]) {
        [self searchWith:string];
    }
}

-(void) textfieldBeginEditing{
    [self.view addSubview:_glassView];
}

-(void) textfieldEndEditing{
    [self.glassView removeFromSuperview];
}

#pragma mark - SearchScrollViewTouchHandler

-(void) accessResultWithType:(NSInteger) type{
    if (type == 3) {
        YHCelebrityResultViewController *result = [[YHCelebrityResultViewController alloc] init];
        result.uid = YHuid;
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:result action: nil];
        self.navigationItem.backBarButtonItem = barButtonItem;
        result.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:result animated:YES];
    }else{
        YHMatchResultViewController *result = [[YHMatchResultViewController alloc] init];
        result.type = type-1;
        result.uid = YHuid;
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:result action: nil];
        self.navigationItem.backBarButtonItem = barButtonItem;
        result.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:result animated:YES];
    }
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
