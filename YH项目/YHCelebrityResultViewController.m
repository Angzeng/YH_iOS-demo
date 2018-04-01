//
//  YHCelebrityResultViewController.m
//  YH项目
//
//  Created by zhujinchi on 16/7/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YHCelebrityResultViewController.h"
#import "YHCelebrityTableViewCell.h"
#import "YHCelebrityViewController.h"
#import "YHLoginViewController.h"
#import "YHInfoPopView.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

@interface YHCelebrityResultViewController ()

@property (nonatomic,strong) UITableView *peopleTab;
@property (nonatomic,readonly) CGSize screenSize;
@property (nonatomic,strong) NSMutableArray *CellsItems;
@property (nonatomic,readwrite) NSUInteger totalPage;
@property (nonatomic,readwrite) BOOL isAccessingData;
@property (nonatomic,readwrite) BOOL noMoreData;
@property (nonatomic,strong) YHInfoPopView *poper;

@end

@implementation YHCelebrityResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _totalPage = 0;
    _isAccessingData = NO;
    _noMoreData = NO;
    _screenSize = [UIScreen mainScreen].bounds.size;
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.title = @"财富先知";
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

-(YHCelebrityTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YHCelebrityTableViewCell *cell = [YHCelebrityTableViewCell cellWithTableView:tableView];
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
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Celebrity/celebrity";
    NSDictionary *parameters = @{@"cid": @"0",@"page":[NSString stringWithFormat:@"%lu",(unsigned long)_totalPage]};
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
                     [_CellsItems removeAllObjects];
                 }
                 __weak typeof(self) weakSelf = self;
                 for(NSString *key in [dict[@"data"] allKeys]){
                     YHMatchResultCellItems *item = [[YHMatchResultCellItems alloc]init];
                     item.uid = key;
                     item.uname = dict[@"data"][key];
                     [weakSelf.CellsItems addObject:item];
                 }
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
    YHCelebrityTableViewCell* cell = (YHCelebrityTableViewCell* )[_peopleTab cellForRowAtIndexPath:indexPath];
    YHCelebrityViewController *celebrity = [[YHCelebrityViewController alloc] init];
    celebrity.itemModel = cell.itemModel;
    celebrity.hidesBottomBarWhenPushed = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1]];
    [self.navigationController pushViewController:celebrity animated:YES];
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
