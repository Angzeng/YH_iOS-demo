//
//  YHCommentViewController.m
//  YH项目
//
//  Created by zhujinchi on 16/7/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YHCommentViewController.h"
#import "YHWriteCommentViewController.h"
#import "YHCommentTableViewCell.h"
#import "YHInfoPopViewController.h"
#import "YHInfoPopViewPresentationController.h"
#import "YHLoginViewController.h"
#import "YHInfoPopView.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

@interface YHCommentViewController ()<UIViewControllerTransitioningDelegate,YHInfoPopViewHandler>

@property (nonatomic,readonly) CGSize screenSize;
@property (nonatomic,readwrite) UIEdgeInsets edgeInset;
@property (nonatomic,strong) YHInfoPopView *poper;
@property (nonatomic, strong) NSMutableArray *CellsItems;
@property (nonatomic,readwrite) BOOL isAccessingData;
@property (nonatomic,readwrite) BOOL noMoreData;
@property (nonatomic, strong) UIWindow *applicationWindow;
@property (nonatomic,readwrite) NSUInteger totalPage;
@property(nonatomic,strong) UIAlertView *alert;

@end

@implementation YHCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _screenSize = [UIScreen mainScreen].bounds.size;
    self.edgeInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"评论";
    
    _CellsItems = [NSMutableArray array];
    _totalPage = 0;
    _isAccessingData = NO;
    _noMoreData = NO;
    
    UITableView *commentTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,_screenSize.width,_screenSize.height-64)];
    commentTable.backgroundColor =[UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
    commentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.commentTab = commentTable;
    [self.view addSubview:commentTable];
    self.commentTab.delegate = self;
    self.commentTab.dataSource = self;
    self.commentTab.showsVerticalScrollIndicator = NO;
   
    __weak typeof(self) weakSelf = self;
    self.commentTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf accessComment:YES];
    }];
    self.commentTab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf accessComment:NO];
    }];
    [self performSelector:@selector(createButton) withObject:nil afterDelay:0];
    
    self.applicationWindow = [UIApplication sharedApplication].keyWindow;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.commentTab.mj_header beginRefreshing];
}

-(void)createButton{
    _hoverbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[_hoverbutton setTitle:@"评论" forState:UIControlStateNormal];
    //_hoverbutton.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_hoverbutton setImage:[UIImage imageNamed:@"addbutton"] forState:UIControlStateNormal];
    _hoverbutton.frame = CGRectMake(_screenSize.width-70,_screenSize.height-160, 50, 50);
    [_hoverbutton addTarget:self action:@selector(windowClick) forControlEvents:UIControlEventTouchUpInside];
    _hoverbutton.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    _hoverbutton.layer.cornerRadius = _hoverbutton.frame.size.width/2;
    _hoverbutton.layer.masksToBounds = YES;
    //    [_hoverview makeKeyAndVisible];
    [self.view addSubview:_hoverbutton];
    
}

- (void)windowClick{
    YHWriteCommentViewController *write = [[YHWriteCommentViewController alloc] init];
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:write action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    write.aid = _aid;
    write.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:write animated:YES];
    
}

#pragma mark - 数据刷新请求- begin

-(void) endRefresh{
    if ([self.commentTab.mj_header isRefreshing]) {
        [self.commentTab.mj_header endRefreshing];
        [self.commentTab.mj_footer resetNoMoreData];
    }
    if ([self.commentTab.mj_footer isRefreshing]) {
        if (_noMoreData) {
            [self.commentTab.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.commentTab.mj_footer endRefreshing];
        }
    }
    _isAccessingData = NO;
}

-(void) accessComment:(BOOL)isRefresh{
    if (_isAccessingData) {
        return;
    }else{
        _isAccessingData = YES;
    }
    if (isRefresh) {
        _totalPage = 0;
    }
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Comment/comment";
    NSDictionary *parameters = @{@"type":@"0",@"aid":_aid,@"uid":@"",@"page":[NSString stringWithFormat:@"%lu",(unsigned long)_totalPage]};
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
                  NSArray *itemArray = [YHCommentCellItems mj_objectArrayWithKeyValuesArray:dict[@"data"]];
                  __weak typeof(self) weakSelf = self;
                  [weakSelf.CellsItems addObjectsFromArray:itemArray];
                  _totalPage += 1;
                  [self.commentTab reloadData];
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

#pragma mark - table － begin

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHCommentTableViewCell* cell = [[YHCommentTableViewCell alloc]initWithFrame:CGRectMake(0, 0, _screenSize.width, 0)];
    cell.itemModel = self.CellsItems[indexPath.section];
    return cell.totalHeight;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.CellsItems.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc ]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(YHCommentTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YHCommentTableViewCell *cell = [YHCommentTableViewCell cellWithTableView:tableView];
    cell.tag = indexPath.section*10000+1;
    cell.itemModel = self.CellsItems[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer *gesture_info;
    gesture_info = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoTap:)];
    [cell.iconImgView addGestureRecognizer:gesture_info];
    return cell;
}

#pragma mark - table － end

#pragma mark - 获取个人信息 － begin

- (void) infoTap:(UIGestureRecognizer *) sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sender.view.tag/10000];
    YHCommentTableViewCell* cell = (YHCommentTableViewCell* )[_commentTab cellForRowAtIndexPath:indexPath];
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

