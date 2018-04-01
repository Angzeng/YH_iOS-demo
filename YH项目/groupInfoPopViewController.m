//
//  YHInfoPopViewController.m
//  YH项目
//
//  Created by 渡。 on 2017/8/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "groupInfoPopViewController.h"
#import "YHLoginViewController.h"
#import "YHInfoPopViewItems.h"
#import "groupInfoPopView.h"
#import "YHArticlesCenterViewController.h"
#import <MJExtension/MJExtension.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "YHConversationViewController.h"
#import "YHmemberMainViewController.h"
#import "GroupmemberlistViewController.h"
#import "GroupfndViewController.h"

@interface groupInfoPopViewController ()

@property(nonatomic,strong) YHInfoPopViewItems *items;
@property(nonatomic,strong) groupInfoPopView *popView;
@property(nonatomic,strong) UIView *maskView;
@property(nonatomic,strong) UIAlertView *textalert;
@property(nonatomic,strong) NSString *YHtargetname;
@property(nonatomic,readwrite) int showdelete;

@end

@implementation groupInfoPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    _maskView = [[UIView alloc] initWithFrame:self.view.frame];
    _maskView.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    _popView = [[groupInfoPopView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_maskView];
    [self.view addSubview:_popView];
    [self accessInfo];
    [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    [_popView.concernBtn addTarget:self action:@selector(focusAuthor) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

-(void)deletefriend {
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Friend/delFriend";
    NSDictionary *parameters = @{@"uid1":YHuid,@"uid2":_UID};
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
                  NSLog(@"%@",dict);
              }
              else{
                  [self presentAlert:@"数据错误"];
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              [self presentAlert:@"网络错误"];
          }];
}

-(void) accessInfo{
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Feature/feature";
    NSDictionary *parameters = @{@"type":@"1",@"uid": _UID,@"muid":YHuid};
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
                  __weak typeof(self)weakSelf = self;
                  weakSelf.items = [YHInfoPopViewItems mj_objectWithKeyValues:dict[@"data"]];
                  [_popView  setItems:self.items];
                  [self isgroupmember:self.groupid :self.UID];
              }
              else{
                  [self presentAlert:@"数据错误"];
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              [self presentAlert:@"网络错误"];
          }];
}

- (void)isgroupmember:(NSString *)stid :(NSString *)suid {
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/TeamUser/isTeamUser";
    NSDictionary *lparameters = @{@"tid":stid,@"uid":suid};
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
              NSString *tempdata = dict[@"data"];
              NSLog(@"aaa%@",dict[@"data"]);
              NSInteger lojudge = [tempdata intValue];
              if (lojudge==0) {
                  [_popView.friendBtn setTitle:@"添加入群" forState:UIControlStateNormal];
                  YHConversationTargetId = _UID;
                  [_popView.friendBtn addTarget:self action:@selector(addmember) forControlEvents:UIControlEventTouchUpInside];
              }
              else if(lojudge==1) {
                  [_popView.friendBtn setTitle:@"请出群组" forState:UIControlStateNormal];
                  YHConversationTargetId = _UID;
                  [_popView.friendBtn addTarget:self action:@selector(deletemember) forControlEvents:UIControlEventTouchUpInside];
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
          }];
}

- (void)deletefriendaction {
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Friend/delFriend";
    NSDictionary *parameters = @{@"uid1":YHuid,@"uid2": _items.uid};
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
                  [self presentAlert:@"已删除好友"];
                  [self backaction];
              }
              else{
                  [self presentAlert:@"数据错误"];
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              [self presentAlert:@"网络错误"];
          }];
}

- (void)backaction {
    UINavigationController *navVC = self.navigationController;
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (UIViewController *vc in [navVC viewControllers]) {
        [viewControllers addObject:vc];
        if ([vc isKindOfClass:[GroupfndViewController class]]) {
            break;
        }
    }
    [navVC setViewControllers:viewControllers animated:YES];
}

-(void)focusAuthor{
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Focus/focus";
    NSDictionary *parameters = @{@"type":_popView.focusType,@"uid2":self.items.uid,@"uid1":YHuid};
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
                  if ([_popView.focusType isEqualToString:@"3"]) {
                      _popView.focusType = @"2";
                  }else{
                      if ([_popView.focusType isEqualToString:@"1"]) {
                          [self presentAlert:@"关注成功"];
                          _popView.focusType = @"2";
                      }else{
                          [self presentAlert:@"取消成功"];
                          _popView.focusType = @"1";
                      }
                  }
                  [_popView changeFocusInfo];
              }else{
                  if ([_popView.focusType isEqualToString:@"3"]) {
                      _popView.focusType = @"1";
                  }else{
                      if ([_popView.focusType isEqualToString:@"1"]) {
                          [self presentAlert:@"关注失败"];
                      }else{
                          [self presentAlert:@"取消失败"];
                      }
                  }
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              if (![_popView.focusType isEqualToString:@"3"]) {
                  [self presentAlert:@"网络错误"];
              }
          }];
}

-(void) addFriend{
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Friend/getFriend";
    NSDictionary *parameters = @{@"uid1":YHuid,@"uid2": _items.uid};
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
                  [self presentAlert:@"已发送好友请求"];
              }
              else{
                  [self presentAlert:@"数据错误"];
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              [self presentAlert:@"网络错误"];
          }];
}

-(void) chat{
    [self dismiss];
    YHConversationViewController *YC = [[YHConversationViewController alloc] init];
    YC.conversationType = 1;
    YC.targetId = YHConversationTargetId;
    [self getuserimformation:YHConversationTargetId];
    
    YC.title = _YHtargetname;
    [self.navigationController pushViewController:YC animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)getuserimformation:(NSString *)targetuid{
    _YHtargetname = nil;
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/User/getUserById";
    NSDictionary *lparameters = @{@"uid":targetuid};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置回复内容信息
    [manager.requestSerializer setValue:YHjwt forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:urlStr
       parameters:lparameters//请求参数
          success:^(AFHTTPRequestOperation * operation, id responseObject){
              NSString *html = operation.responseString;
              NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
              id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
              NSString *judge = dict[@"code"];
              NSInteger lojudge = [judge intValue];
              if (lojudge == 200) {
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

- (void)addmember{
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/TeamUser/joinTeamUser";
    NSDictionary *lparameters = @{@"tid":self.groupid,@"uid":self.UID,@"name":self.groupname};
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
                  [self presentAlert:@"添加成功"];
                  [self backaction];
              }else{
                  NSLog(@"%@",dict);
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
          }];
}

- (void)deletemember{
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/TeamUser/outTeamUser";
    NSString *ggg = [NSString stringWithFormat:@"%@%@%@",@"[",self.UID,@"]"];
    NSLog(@"%@",ggg);
    NSDictionary *lparameters = @{@"tid":self.groupid,@"uids":ggg};
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
                  [self presentAlert:@"删除成功"];
                  [self backaction];
              }else{
                  NSLog(@"%@",dict);
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
          }];
}

- (void)dismiss {
    //[self dismissViewControllerAnimated:NO completion:^{}];
}

-(void) presentAlert:(NSString*)content{
    //设置alert时间响应
    _textalert = [[UIAlertView alloc]initWithTitle:content message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
    [_textalert show];
}

-(void) performDismiss:(NSTimer *)timer
{
    [_textalert dismissWithClickedButtonIndex:0 animated:NO];
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
