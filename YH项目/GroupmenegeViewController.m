//
//  GroupmenegeViewController.m
//  YH项目
//
//  Created by Angzeng on 17/08/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "GroupmenegeViewController.h"
#import "AFNetworking.h"
#import "YHLoginViewController.h"
#import "GroupmemeberTableViewController.h"
#import "RCInfoPopViewController.h"
#import "YHmemberMainViewController.h"

@interface GroupmenegeViewController ()

@property (nonatomic , strong) NSString *YHtargetname;
@property (nonatomic , strong) UIAlertView *alert;
@property (strong , nonatomic) GroupmemeberTableViewController *groupmemberlist;

@end

@implementation GroupmenegeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAdd];
    self.navigationItem.title = @"群组用户列表";
    self.view.backgroundColor = [UIColor whiteColor];
    [self inittableview];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(initinfoview) name:@"loadinfo" object:nil];
    // Do any additional setup after loading the view.
}

- (void)setupAdd {
    UIButton * AddButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [AddButton setTitle:@"退出" forState:UIControlStateNormal];
    AddButton.backgroundColor = [UIColor clearColor];
    AddButton.titleLabel.textColor = [UIColor whiteColor];
    [AddButton addTarget:self action:@selector(deletegroup) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithCustomView:AddButton];
    self.navigationItem.rightBarButtonItem=rightItem;
}

- (void)deletegroup {
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/TeamUser/outTeamUser";
    NSString *ggg = [NSString stringWithFormat:@"%@%@%@",@"[",YHuid,@"]"];
    NSLog(@"%@",ggg);
    NSDictionary *lparameters = @{@"tid":self.tid,@"uids":ggg};
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
                  [self presentAlert:@"退出成功"];
                  [self backaction];
              }else{
                  [self presentAlert:@"退出失败"];
                  [self backaction];
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              [self presentAlert:@"网络错误"];
          }];
}

- (void)initinfoview {
    RCInfoPopViewController *temp = [[RCInfoPopViewController alloc] init];
    temp.UID = YHConversationTargetId;
    [self getuserinformation:temp.UID];
    temp.ifshowdelete = @"YES";
    temp.title = _YHtargetname;
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

- (void)inittableview {
    _groupmemberlist = [[GroupmemeberTableViewController alloc] init];
    _groupmemberlist.managerid = self.managerid;
    _groupmemberlist.tid = self.tid;
    _groupmemberlist.view.frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_groupmemberlist.view];
    self.groupmemberlist = _groupmemberlist;
    self.groupmemberlist.title = @"群成员列表";
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
