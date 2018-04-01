//
//  ViewController.m
//  个人中心
//
//  Created by Apple on 15/10/16.
//  Copyright © 2015年 Apple. All rights reserved.
//
#import "GRZXmainController.h"
#import "GRZXmenu.h"
#import "GRZXmenuGroup.h"
#import "GRZXrowCell.h"
#import "GRZXheadCell.h"
#import "GRZXuser.h"
#import "GRZXtreaPageViewController.h"
#import "GRZXcollectPageViewController.h"
#import "GRZXaboutPageViewController.h"
#import "GRZXsettingPageViewController.h"
#import "GRZXeditInfoController.h"
#import "AFNetworking.h"
#import "YHLoginViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>

@interface GRZXmainController () <UITableViewDataSource,UITableViewDelegate,headCellDelegate,GRZXeditInfoControllerdelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *menus;
@property (nonatomic,strong) GRZXuser *user;
@property (nonatomic,strong) UIAlertView *loginalert;

@end

@implementation GRZXmainController


//懒加载数据
-(NSArray *)menus{
    if (_menus == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"personCenter.plist" ofType:nil];
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in array) {
            GRZXmenuGroup *menu = [GRZXmenuGroup menugroupWithDict:dict];
            [arr addObject:menu];
        }
        _menus=arr;
    }
    return _menus;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [self endRefresh];
    }];
    self.tableView.mj_header = header;
    self.tabBarController.tabBar.hidden = NO;
}

-(void) endRefresh{
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
}

//编辑界面跳转
-(void)goEditViewWithCell:(GRZXheadCell *)cell{
    [self performSegueWithIdentifier:@"main2edit" sender:nil];
    self.tabBarController.tabBar.hidden = YES;
}

//回跳代理方法
-(void)saveInfoWithControl:(GRZXeditInfoController *)controller andUser:(GRZXuser *)user{
    self.user = user;
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[GRZXeditInfoController class]]) {
        GRZXeditInfoController *editView = segue.destinationViewController;
        editView.user = self.user;
        editView.delegate = self;
    }
}

// 界面跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1]];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    if (indexPath.section == 1){
        if (indexPath.row == 0 ){
            GRZXcollectPageViewController *view = [[GRZXcollectPageViewController alloc]init];
            view.hidesBottomBarWhenPushed = YES;
            [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1]];
            [self.navigationController pushViewController:view animated:YES];
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            GRZXsettingPageViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"set_page"];
            [self.navigationController pushViewController:view animated:YES];
            self.tabBarController.tabBar.hidden = YES;
        }else{
            GRZXaboutPageViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"about_page"];
            [self.navigationController pushViewController:view animated:YES];
            self.tabBarController.tabBar.hidden = YES;
        }
    }else if(indexPath.section == 3){
        
    }
}

//返回多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.menus.count+1;
}
// 返回每组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
    GRZXmenuGroup *group = self.menus[section-1];
    return group.groupContent.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GRZXheadCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"GRZXheadCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.user = self.user;
        return cell;
    }else{
    //加载数据
    GRZXmenuGroup *group =self.menus[indexPath.section-1];
    GRZXmenu *menu = group.groupContent[indexPath.row];
    // 设置单元格
    GRZXrowCell *cell = [GRZXrowCell rowCellWithTableView:tableView];
    // 将数据设置给单元格
    cell.menu = menu;
    //返回单元格
    return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 88;
    }
    return 44;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self startthisview];
}

- (void)startthisview{
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/User/user";
    NSDictionary *parameters = @{@"uid":YHuid};
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
              _iconavater = dict[@"data"][0][@"avatar"];
              self.user = [GRZXuser userWithName:dict[@"data"][0][@"uname"] work:dict[@"data"][0][@"industry"] address:dict[@"data"][0][@"region"] icon:@"headIcon_bottom.png" phoneNumber:@"13327043302" age:dict[@"data"][0][@"birthday"] andSex:dict[@"data"][0][@"gender"]];
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              
          }];

    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 64;
    
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    
    //导航栏背景及文字颜色修改
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    self.navigationItem.title= @"个人中心";
}

-(void) performDismiss:(NSTimer *)timer
{
    [_loginalert dismissWithClickedButtonIndex:0 animated:NO];
    //    [_registeralert release];
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
