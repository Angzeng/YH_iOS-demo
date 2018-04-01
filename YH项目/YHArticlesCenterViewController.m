//
//  ArticlesCenterViewController.m
//  Test
//
//  Created by Zero on 15/11/7.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "YHArticlesCenterViewController.h"
#import "YHInfoPopViewController.h"
#import "YHInfoPopViewPresentationController.h"
#import "YHSegmentedScrollView.h"
#import "YHArticleViewController.h"
#import "YHArticlesTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "YHWriteTitleViewController.h"
#import "YHInfoPopView.h"
#import "YHLoginViewController.h"
#import <AFNetworking/AFHTTPRequestOperation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
@interface YHArticlesCenterViewController()<YHSegmTouchHandler,UIViewControllerTransitioningDelegate,YHInfoPopViewHandler>

@property (nonatomic,strong) YHInfoPopView *poper;
@property (nonatomic,strong) YHSegmentedScrollView *segm;
@property (nonatomic,readonly) CGSize screenSize;
@property (nonatomic,strong) NSMutableArray *CellsItems;
@property (nonatomic,readwrite) NSUInteger totalPage;
@property (nonatomic,readwrite) BOOL isAccessingData;
@property (nonatomic,readwrite) BOOL noMoreData;
@property (nonatomic,readwrite) NSInteger typeOfArticlesShowing;
@property (nonatomic,readwrite) NSInteger typeOfArticlesToShow;
@property (nonatomic,strong) UIAlertView *alert;

@end

@implementation YHArticlesCenterViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    _screenSize = [UIScreen mainScreen].bounds.size;
    self.poper = nil;
    self.totalPage = 0;
    self.CellsItems = [NSMutableArray array];
    for(int i=0;i<6;i++){
        [self.CellsItems addObject:[NSMutableArray array]];
    }
    self.isAccessingData = NO;
    self.noMoreData = NO;
    
    self.view.backgroundColor = [UIColor clearColor];
    [self.view setUserInteractionEnabled:YES];
    //导航栏背景及文字颜色修改
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1]];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title = @"文章";
    [self performSelector:@selector(createButton) withObject:nil afterDelay:0];
    [self createUI];
    
    //    [self addrightButton];
    // Do any additional setup after loading the view.
}

-(void)createUI{
    //设置segment
    YHSegmentedScrollView *segmented = [[YHSegmentedScrollView alloc]initWithFrame:CGRectMake(0, 0, _screenSize.width, self.navigationController.navigationBar.frame.size.height)];
    segmented.segmTouchHandlerDelegate = self;
    [self.view addSubview:segmented];
    self.segm = segmented;
    
    //设置table
    UITableView *articlesTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.segm.frame.size.height, _screenSize.width, _screenSize.height - self.segm.frame.size.height - 108)];
    articlesTable.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
    articlesTable.separatorStyle = UITableViewCellSelectionStyleNone;
    self.articlesTab = articlesTable;
    [self.view addSubview:articlesTable];
    
    //设置上拉和下拉刷新
    self.articlesTab.delegate = self;
    self.articlesTab.dataSource = self;
    __weak typeof(self) weakSelf = self;
    self.articlesTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf accessArticle:YES];
    }];
    self.articlesTab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf accessArticle:NO];
    }];
    [self segmentedControlChangedValue:_segm];
    
}

-(void)createButton{
    _hoverbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [_hoverbutton setTitle:@"button" forState:UIControlStateNormal];
    [_hoverbutton setImage:[UIImage imageNamed:@"addbutton"] forState:UIControlStateNormal];
    _hoverbutton.frame = CGRectMake(0, 0, 50, 50);
    [_hoverbutton addTarget:self action:@selector(windowClick) forControlEvents:UIControlEventTouchUpInside];
    _hoverview= [[UIView alloc]initWithFrame:CGRectMake(_screenSize.width-70,_screenSize.height-180, 50, 50)];
    _hoverview.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    _hoverview.layer.cornerRadius = 25;
    _hoverview.layer.masksToBounds = YES;
    [_hoverview addSubview:_hoverbutton];
    //    [_hoverview makeKeyAndVisible];
    [self.view addSubview:_hoverview];
    
}

-(void)registerWindow{
    [_hoverview removeFromSuperview];
}
//
-(void)openWindow{
    [self performSelector:@selector(createButton) withObject:nil afterDelay:1];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (void)windowClick{
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.backBarButtonItem=backItem;
    YHWriteTitleViewController *write = [[YHWriteTitleViewController alloc] init];
    [self.navigationController pushViewController:write animated:YES];
    
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
    [self presentViewController:popViewController animated:NO completion:^{}];
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
    NSMutableArray *array =[self.CellsItems objectAtIndex:_typeOfArticlesShowing];
    return array.count;
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
    NSMutableArray *array = self.CellsItems[_typeOfArticlesShowing];
    if (array.count>indexPath.section) {
        cell.itemModel = self.CellsItems[_typeOfArticlesShowing][indexPath.section];
    }
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
    NSDictionary *parameters = @{@"type":[NSString stringWithFormat:@"%ld",(long)_typeOfArticlesToShow],@"page":[NSString stringWithFormat:@"%lu",(unsigned long)_totalPage],@"uid":YHuid};
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/Article/article";
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
                 if (isRefresh) {
                     [_CellsItems[_typeOfArticlesToShow] removeAllObjects];
                 }
                 NSArray *itemArray = [YHArticlesCellItems mj_objectArrayWithKeyValuesArray:dict[@"data"]];
                 __weak typeof(self) weakSelf = self;
                 [weakSelf.CellsItems[_typeOfArticlesToShow] addObjectsFromArray:itemArray];
                 _totalPage += 1;
                 _noMoreData = NO;
             }else{
                 _noMoreData = YES;
             }
             _typeOfArticlesShowing = _typeOfArticlesToShow;
             [self.articlesTab reloadData];
             [self endRefresh];
         }
         failure:^(AFHTTPRequestOperation * operation, NSError * error) {
             [self endRefresh];
         }];
}

//segment切换时，请求刷新数据
-(void) segmentedControlChangedValue:(YHSegmentedScrollView *)segmented{
    [self endRefresh];
    [self.articlesTab setContentOffset:CGPointZero];
    _typeOfArticlesToShow = segmented.selectedIndex;
    NSMutableArray *array = [self.CellsItems objectAtIndex:_typeOfArticlesToShow];
    if (array.count == 0) {
        [self.articlesTab.mj_header beginRefreshing];
    }else{
        [self.articlesTab setContentOffset:CGPointZero animated:YES];
        [UIView animateWithDuration:0 animations:^{
            _typeOfArticlesShowing = _typeOfArticlesToShow;
            [self.articlesTab reloadData];
        } completion:^(BOOL finished) {
            _totalPage = (NSInteger)ceil(array.count/10.0);
        }];
    }
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
