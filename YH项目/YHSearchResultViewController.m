//
//  YHSearchResultViewController.m
//  YH项目
//
//  Created by zhujinchi on 16/7/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YHSearchResultViewController.h"
#import "YHSearchResultTableViewCell.h"
#import "YHInfoPopViewPresentationController.h"
#import "YHInfoPopViewController.h"
#import "YHInfoPopView.h"
#import "YHSearchBar.h"
#import "YHLoginViewController.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

@interface YHSearchResultViewController ()<YHSearchBarTouchHandler,UIViewControllerTransitioningDelegate,YHInfoPopViewHandler>

@property (nonatomic,strong) NSArray *CellsItems;
@property (nonatomic,readonly) CGSize screenSize;
@property (nonatomic,strong) UITableView *peopleTab;
@property (nonatomic,strong) YHInfoPopView *poper;
@property(nonatomic,strong) UIAlertView *alert;
@property(nonatomic,strong) UIView *glassView;
@property(nonatomic,strong) YHSearchBar *searchBar;

@end

@implementation YHSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _screenSize = [UIScreen mainScreen].bounds.size;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self.navigationController.view addGestureRecognizer:tapGestureRecognizer];
    [self createUI];
}

-(void)createUI{
    YHSearchBar *searchBar = [[YHSearchBar alloc] initWithFrame:CGRectMake(0, 20, _screenSize.width, 44)WithType:NO];
    searchBar.searchBarTouchHandlerDelegate = self;
    [self.navigationController.view addSubview: searchBar];
    _searchBar = searchBar;
    
    UITableView *peopleTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _screenSize.width, _screenSize.height-64)];
    peopleTable.backgroundColor =[UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
    peopleTable.separatorStyle = UITableViewCellSelectionStyleNone;
    self.peopleTab = peopleTable;
    [self.view addSubview:peopleTable];
    self.peopleTab.delegate = self;
    self.peopleTab.dataSource = self;
    
    _glassView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _peopleTab.frame.size.width,  _peopleTab.frame.size.height)];
    _glassView.backgroundColor = [UIColor blackColor];
    _glassView.alpha = 0.7;
    
    [self accessResult];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return _CellsItems.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc ]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

-(YHSearchResultTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YHSearchResultTableViewCell *cell = [YHSearchResultTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.section*10000+1;
    cell.itemModel = self.CellsItems[indexPath.section];
    [cell setItemModel];
    UITapGestureRecognizer *gesture;
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
    [cell addGestureRecognizer:gesture];
    [cell setNeedsDisplay];
    return cell;
}

-(void)accessResult{
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Search/search";
    NSDictionary *parameters = @{@"uname":_string};
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
                 weakSelf.CellsItems = [YHMatchResultCellItems mj_objectArrayWithKeyValuesArray:dict[@"data"]];
             }else{
                 _CellsItems = [NSArray array];
                 [self presentAlert:@"没有找到相关结果"];
             }
             [self.peopleTab reloadData];
         }
         failure:^(AFHTTPRequestOperation * operation, NSError * error) {
             [self presentAlert:@"网络错误"];
         }];
}

-(void) cellTapped:(UIGestureRecognizer *) sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sender.view.tag/10000];
    YHSearchResultTableViewCell* cell = (YHSearchResultTableViewCell* )[_peopleTab cellForRowAtIndexPath:indexPath];
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

#pragma mark - SearchBarTouchHandler

-(void) buttonTapWith:(NSString *)string{
    if ([self isBlankString:string]) {
        [self.searchBar removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        _string = string;
        [self accessResult];
    }
}

-(void) textfieldBeginEditing{
    [self.view addSubview:_glassView];
}

-(void) textfieldEndEditing{
    [self.glassView removeFromSuperview];
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
