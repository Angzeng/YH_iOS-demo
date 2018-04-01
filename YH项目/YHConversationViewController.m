//
//  YHConversationViewController.m
//  YH项目
//
//  Created by Angzeng on 2017/6/29.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YHConversationViewController.h"
#import "YHInfoPopView.h"
#import "AFNetworking.h"
#import "YHLoginViewController.h"
#import "YHCelebrityViewController.h"
#import "YHSearchViewController.h"
#import "YHInfoPopViewController.h"
#import "RCInfoPopViewController.h"
#import "YHmemberMainViewController.h"

@interface YHConversationViewController ()

@property (nonatomic , strong) YHInfoPopView *poper;
@property (nonatomic , strong) UIView *maskView;
@property (nonatomic , strong) NSString *userinfoid;
@property (nonatomic , strong) NSString *YHtargetname;
@property (nonatomic , strong) UIAlertView *textalert;
@property (nonatomic , strong) NSString *deleteid;

@end

@implementation YHConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.got isEqualToString:@"got"]) {
        [self setupInfo];
    }
    // Do any additional setup after loading the view.
}

- (void)setupInfo {  //添加按钮
    UIButton * AddButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [AddButton setImage:[UIImage imageNamed:@"information_done"] forState:UIControlStateNormal];
    [AddButton addTarget:self action:@selector(getinfo) forControlEvents:UIControlEventTouchDown];
    //这里添加上传事件响应
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithCustomView:AddButton];
    self.navigationItem.rightBarButtonItem=rightItem;
}

- (void)getinfo {
    RCInfoPopViewController *temp = [[RCInfoPopViewController alloc] init];
    temp.UID = YHConversationTargetId;
    _deleteid = YHConversationTargetId;
    temp.ifshowdelete = @"YES";
    //temp.view = prepare;
    [self getuserinformation:YHConversationTargetId];
    temp.title = _YHtargetname;
    temp.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:temp animated:YES];
}

- (void)didTapCellPortrait:(NSString *)userId {
    RCInfoPopViewController *temp = [[RCInfoPopViewController alloc] init];
    temp.UID = userId;
    _deleteid = userId;
    temp.ifshowdelete = @"YES";
    //temp.view = prepare;
    [self getuserinformation:userId];
    temp.title = _YHtargetname;
    temp.view.backgroundColor = [UIColor whiteColor];
    //    [self.view addSubview:temp.view];
    [self.navigationController pushViewController:temp animated:YES];
}

-(void) presentAlert:(NSString*)content{
    //设置alert时间响应
    _textalert = [[UIAlertView alloc]initWithTitle:content message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
    [_textalert show];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
