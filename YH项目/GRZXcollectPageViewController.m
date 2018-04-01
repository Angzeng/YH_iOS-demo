//
//  GRZXcollectPageViewController.m
//  个人中心
//
//  Created by Apple on 15/10/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "GRZXcollectPageViewController.h"
#import "YHArticlesTableViewCell.h"
#import "YHInfoPopView.h"
#import "YHInfoPopViewPresentationController.h"
#import "YHInfoPopViewController.h"
#import "YHArticleViewController.h"
#import "YHLoginViewController.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

@interface GRZXcollectPageViewController () <UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate,YHInfoPopViewHandler>

@property (nonatomic,strong) UITableView *articlesTab;
@property (nonatomic,strong) YHInfoPopView *poper;
@property (nonatomic,strong) NSMutableArray *CellsItems;
@property (nonatomic,readwrite) NSUInteger totalPage;
@property (nonatomic,readwrite) BOOL isAccessingData;
@property (nonatomic,readwrite) BOOL noMoreData;
@property (nonatomic,readonly) CGSize screenSize;
@property(nonatomic,strong) UIAlertView *alert;

@end

@implementation GRZXcollectPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _screenSize = [UIScreen mainScreen].bounds.size;
    self.navigationItem.title= @"我的收藏";
    
    self.totalPage = 0;
    self.CellsItems = [NSMutableArray array];
    self.isAccessingData = NO;
    self.noMoreData = NO;
    
    UITableView *articlesTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _screenSize.width, _screenSize.height - 64)];
    articlesTable.backgroundColor =[UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
    articlesTable.separatorStyle = UITableViewCellSelectionStyleNone;
    self.articlesTab = articlesTable;
    [self.view addSubview:articlesTable];
    self.articlesTab.dataSource =self;
    self.articlesTab.delegate = self;
    __weak typeof(self) weakSelf = self;
    self.articlesTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf accessArticle:YES];
    }];
    self.articlesTab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf accessArticle:NO];
    }];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [self accessArticle:YES];
}

- (void) buttonTap:(UIGestureRecognizer *) sender{
    YHArticlesTableViewCell* cell = (YHArticlesTableViewCell* )sender.view;
    YHArticleViewController *article = [[YHArticleViewController alloc] initWithItems:cell.itemModel];
    article.hidesBottomBarWhenPushed = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1]];
    [self.navigationController pushViewController:article animated:YES];
}

#pragma mark - 获取个人信息 － begin

- (void) infoTap:(UIGestureRecognizer *) sender{
    YHArticlesTableViewCell* cell = (YHArticlesTableViewCell* )sender.view.superview.superview;
    YHInfoPopViewController *popViewController = [[YHInfoPopViewController alloc] init];
    popViewController.UID = cell.itemModel.uid;
    self.definesPresentationContext = YES;
    popViewController.modalPresentationStyle = UIModalPresentationCustom;
    popViewController.transitioningDelegate = self;
    popViewController.InfoPopViewHandlerDelegate = self;
    [self presentViewController:popViewController animated:NO completion:^{
    }];
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    return [[YHInfoPopViewPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    
}

-(id)getNavigationController{
    return [self navigationController];
}

#pragma mark - 获取个人信息 － end

#pragma mark - table － begin

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.CellsItems.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc ]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(YHArticlesTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YHArticlesTableViewCell *cell = [YHArticlesTableViewCell cellWithTableView:tableView];
    cell.itemModel = self.CellsItems[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer *gesture_art;
    gesture_art = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTap:)];
    [cell addGestureRecognizer:gesture_art];
    UITapGestureRecognizer *gesture_info;
    gesture_info = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoTap:)];
    [cell.iconImgView addGestureRecognizer:gesture_info];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

#pragma mark - table － end

#pragma mark - 数据刷新请求- begin

-(void) endRefresh{
    if ([self.articlesTab.mj_header isRefreshing]) {
        [self.articlesTab.mj_header endRefreshing];
        [self.articlesTab.mj_footer resetNoMoreData];
    }
    if ([self.articlesTab.mj_footer isRefreshing]) {
        if (_noMoreData) {
            [self.articlesTab.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.articlesTab.mj_footer endRefreshing];
        }
    }
    _isAccessingData = NO;
}

-(void) accessArticle:(BOOL)isRefresh{
    if (_isAccessingData) {
        return;
    }else{
        _isAccessingData = YES;
    }
    if (isRefresh) {
        _totalPage = 0;
    }
    NSDictionary *parameters = @{@"type":@0,@"page":[NSString stringWithFormat:@"%lu",(unsigned long)_totalPage],@"uid":YHuid};
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/Collect/collect";
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
                 if (isRefresh) {
                     [_CellsItems removeAllObjects];
                 }
                 NSArray *itemArray = [YHArticlesCellItems mj_objectArrayWithKeyValuesArray:dict[@"data"]];
                 __weak typeof(self) weakSelf = self;
                 [weakSelf.CellsItems addObjectsFromArray:itemArray];
                 _totalPage += 1;
                 [self.articlesTab reloadData];
                 _noMoreData = NO;
             }else{
                 _noMoreData = YES;
             }
             [self endRefresh];
         }
         failure:^(AFHTTPRequestOperation * operation, NSError * error) {
             [self endRefresh];
         }];
}

#pragma mark - 数据刷新请求 - end

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
