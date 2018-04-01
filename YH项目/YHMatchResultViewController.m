//
//  YHResultViewController.m
//  YH项目
//
//  Created by Apple on 16/3/9.
//  Copyright (c) 2016年 Apple. All rights reserved.
//

#import "YHMatchResultViewController.h"
#import "YHMatchResultTableViewCell.h"
#import "YHCelebrityViewController.h"
#import "YHInfoPopViewPresentationController.h"
#import "YHInfoPopViewController.h"
#import "YHLoginViewController.h"
#import "YHInfoPopView.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

@interface YHMatchResultViewController ()<UIViewControllerTransitioningDelegate,YHInfoPopViewHandler>

@property (nonatomic,strong) UITableView *peopleTab;
@property (nonatomic,readonly) CGSize screenSize;
@property (nonatomic,strong) NSMutableArray *CellsItems;
@property (nonatomic,readwrite) NSUInteger totalPage;
@property (nonatomic,readwrite) BOOL isAccessingData;
@property (nonatomic,readwrite) BOOL noMoreData;
@property (nonatomic,strong) YHInfoPopView *poper;
@property (nonatomic,strong) UIAlertView *alert;

@end

@implementation YHMatchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _totalPage = 0;
    _screenSize = [UIScreen mainScreen].bounds.size;
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    if (_type == 0) {
        self.navigationItem.title = @"志同道合";
    }else{
        self.navigationItem.title = @"优势互补";
    }
    
    [self creatUI];
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    UITableView *peopleTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _screenSize.width, _screenSize.height-64)];
    peopleTable.backgroundColor =[UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
    peopleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.peopleTab = peopleTable;
    self.peopleTab.delegate = self;
    self.peopleTab.dataSource = self;
    _CellsItems = [NSMutableArray array];
    _totalPage = 0;
    _isAccessingData = NO;
    _noMoreData = NO;
    __weak typeof(self) weakSelf = self;
    self.peopleTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf accessResult:YES];
    }];
    self.peopleTab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf accessResult:NO];
    }];
    [self.view addSubview:_peopleTab];
    [self accessResult:YES];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return _CellsItems.count;
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
    return 3;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

-(YHMatchResultTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YHMatchResultTableViewCell *cell = [YHMatchResultTableViewCell cellWithTableView:tableView];
    cell.tag = indexPath.section*10000+1;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.itemModel = self.CellsItems[indexPath.section];
    [cell setItemModel];
    UITapGestureRecognizer *gesture;
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
    [cell addGestureRecognizer:gesture];
    [cell setNeedsDisplay];
    return cell;
}

-(void) endRefresh{
    if ([self.peopleTab.mj_header isRefreshing]) {
        [self.peopleTab.mj_header endRefreshing];
        [self.peopleTab.mj_footer resetNoMoreData];
    }
    if ([self.peopleTab.mj_footer isRefreshing]) {
        if (_noMoreData) {
            [self.peopleTab.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.peopleTab.mj_footer endRefreshing];
        }
    }
    _isAccessingData = NO;
}

-(void) accessResult:(BOOL)isRefresh{
    if (_isAccessingData) {
        return;
    }else{
        _isAccessingData = YES;
    }
    if (isRefresh) {
        _totalPage = 0;
    }
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/GetModel/getModel";
    NSDictionary *parameters = @{@"type":[NSString stringWithFormat:@"%ld",(long)_type],@"uid":_uid,@"page":[NSString stringWithFormat:@"%lu",(unsigned long)_totalPage]};
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
                  NSArray *itemArray = [YHMatchResultCellItems mj_objectArrayWithKeyValuesArray:dict[@"data"]];
                  __weak typeof(self) weakSelf = self;
                  [weakSelf.CellsItems addObjectsFromArray:itemArray];
                  _totalPage += 1;
                  [self.peopleTab reloadData];
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

-(void) cellTapped:(UIGestureRecognizer *) sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sender.view.tag/10000];
    YHMatchResultTableViewCell* cell = (YHMatchResultTableViewCell* )[_peopleTab cellForRowAtIndexPath:indexPath];
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
