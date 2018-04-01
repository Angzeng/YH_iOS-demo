//
//  GroupmemberlistViewController.m
//  YH项目
//
//  Created by Angzeng on 27/08/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "GroupmemberlistViewController.h"
#import "GroupmemberlistTableViewController.h"
#import "AFNetworking.h"
#import "YHLoginViewController.h"
#import "GroupmemeberTableViewController.h"
#import "RCInfoPopViewController.h"
#import "YHmemberMainViewController.h"
#import "groupInfoPopViewController.h"

@interface GroupmemberlistViewController ()

@property (nonatomic , strong) NSString *YHtargetname;
@property (nonatomic , strong) UIAlertView *alert;
@property (nonatomic , strong) UITableViewController *tableview;
@property (nonatomic , strong) groupInfoPopViewController *temp;

@end

@implementation GroupmemberlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"好友列表";
    GroupmemberlistTableViewController *tableview = [[GroupmemberlistTableViewController alloc] init];
    tableview.tid = self.tid;
    tableview.tname = self.tname;
    tableview.view.frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:tableview.view];
    self.tableview = tableview;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(initinfoview) name:@"loadinfopro" object:nil];
    // Do any additional setup after loading the view.
}



- (void)initinfoview {
    //
    groupInfoPopViewController *temp = [[groupInfoPopViewController alloc] init];
    temp.UID = YHConversationTargetId;
    [self getuserinformation:temp.UID];
    temp.ifshowdelete = @"YES";
    temp.title = _YHtargetname;
    //
    temp.groupname = self.tname;
    temp.groupid = self.tid;
    //
    temp.view.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backaction {
    UINavigationController *navVC = self.navigationController;
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (UIViewController *vc in [navVC viewControllers]) {
        [viewControllers addObject:vc];
        if ([vc isKindOfClass:[YHmemberMainViewController class]]) {
            break;
        }
    }
    [navVC setViewControllers:viewControllers animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
