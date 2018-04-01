//
//  YHGroupConversationViewController.m
//  YH项目
//
//  Created by Angzeng on 14/08/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "YHGroupConversationViewController.h"
#import "YHInfoPopView.h"
#import "AFNetworking.h"
#import "YHLoginViewController.h"
#import "YHCelebrityViewController.h"
#import "YHSearchViewController.h"
#import "YHInfoPopViewController.h"
#import "RCInfoPopViewController.h"
#import "YHmemberMainViewController.h"
#import "GroupmenegeViewController.h"
#import "GroupfndViewController.h"

@interface YHGroupConversationViewController ()

@property (nonatomic , strong) NSString *YHtargetname;
@property (nonatomic , strong) UIAlertView *textalert;
@property (nonatomic , strong) NSString *deleteid;

@end

@implementation YHGroupConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupgroupInfo];
    // Do any additional setup after loading the view.
}

- (void)setupgroupInfo {  //添加按钮
    UIButton * AddButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [AddButton setImage:[UIImage imageNamed:@"information_done"] forState:UIControlStateNormal];
    //[AddButton setBackgroundColor:[UIColor whiteColor]];
    [AddButton addTarget:self action:@selector(getgroupinfo) forControlEvents:UIControlEventTouchUpInside];
    //这里添加上传事件响应
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithCustomView:AddButton];
    self.navigationItem.rightBarButtonItem=rightItem;
}

- (void)didTapCellPortrait:(NSString *)userId {
    RCInfoPopViewController *temp = [[RCInfoPopViewController alloc] init];
    temp.UID = userId;
    //temp.view = prepare;
    [self getuserinformation:userId];
    temp.title = _YHtargetname;
    temp.view.backgroundColor = [UIColor whiteColor];
    //    [self.view addSubview:temp.view];
    [self.navigationController pushViewController:temp animated:YES];
}

- (void)getuserinformation:(NSString *)targetuid{
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/User/getUserById";
    NSDictionary *lparameters = @{@"uid":targetuid};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置回复内容信息
    [manager.requestSerializer setValue:YHjwt forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:urlStr
       parameters:lparameters//请求参数
          success:^(AFHTTPRequestOperation * operation, id responseObject) {
              NSString *html = operation.responseString;
              NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
              id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
              NSString *judge = dict[@"code"];
              NSInteger lojudge = [judge intValue];
              if (lojudge == 200) {
                  NSLog(@"显示为%@",dict[@"data"][@"uname"]);
                  _YHtargetname = dict[@"data"][@"uname"];
              }else{
                  NSLog(@"error");
                  _YHtargetname = @"无信息用户";
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
              _YHtargetname = @"无信息用户";
          }];
}

- (void)getgroupinfo {
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/Team/getTeamInfo";
    NSDictionary *lparameters = @{@"tid":YHConversationTargetId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置回复内容信息
    [manager.requestSerializer setValue:YHjwt forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:urlStr
       parameters:lparameters//请求参数
          success:^(AFHTTPRequestOperation * operation, id responseObject) {
              NSString *html = operation.responseString;
              NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
              id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
              NSString *judge = dict[@"code"];
              NSInteger lojudge = [judge intValue];
              if (lojudge == 200) {
                  NSLog(@"显示为%@",dict);
                  NSLog(@"显示为%@",dict[@"data"][0][@"avatar"]);
                  NSLog(@"显示为%@",dict[@"data"][0][@"fnd_uid"]);
                  NSLog(@"%@",YHuid);
                  if([YHuid isEqualToString:dict[@"data"][0][@"fnd_uid"]]){
                      [self showmanage:dict[@"data"][0][@"fnd_uid"] :YHConversationTargetId];
                  }
                  else{
                      [self showgroup:dict[@"data"][0][@"fnd_uid"] :YHConversationTargetId];
                  }
              }else{
                  NSLog(@"error");
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
          }];
}

- (void)showmanage:(NSString *)managerid :(NSString *)tid {
    GroupfndViewController *groupmanage = [[GroupfndViewController alloc] init];
    groupmanage.managerid = managerid;
    groupmanage.tid = tid;
    groupmanage.tname = self.title;
    [self.navigationController pushViewController:groupmanage animated:YES];
}

- (void)showgroup:(NSString *)managerid :(NSString *)tid {
    GroupmenegeViewController *groupinfo = [[GroupmenegeViewController alloc] init];
    groupinfo.managerid = managerid;
    groupinfo.tid = tid;
    [self.navigationController pushViewController:groupinfo animated:YES];
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
