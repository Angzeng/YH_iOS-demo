//
//  AddFriendViewController.m
//  YH项目
//
//  Created by Apple on 2017/6/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AddFriendViewController.h"
#import "AFNetworking.h"
#import "YHLoginViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AddFriendViewController ()

@property (strong , nonatomic) UISearchBar *SearchUser;
@property (nonatomic) BOOL showsCancelButton;
@property (nonatomic , strong) NSString *Addstring;
@property (nonatomic , strong) UIAlertView *alert;
@property (nonatomic , strong) UIButton *searchButton;
@property (nonatomic , strong) NSString *uid1;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _Addstring = nil;
    [self settitleview];
    [self setsearchview];
}

- (void)settitleview {
    self.navigationItem.title = @"查找用户";
    _SearchUser = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-50, 50)];
    _SearchUser.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    [_SearchUser setBarTintColor:[UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1]];
    _SearchUser.searchBarStyle =UISearchBarStyleMinimal;
    _SearchUser.placeholder = @"请输入用户名称...";
    [_SearchUser becomeFirstResponder];
    [self.view addSubview:_SearchUser];
}

- (void)setsearchview {
    self.view.backgroundColor = [UIColor whiteColor];
    _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 0, 50, 50)];
    _searchButton.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    [_searchButton setImage:[UIImage imageNamed:@"search_done.png"] forState:UIControlStateNormal];
    [_searchButton addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchButton];
}

- (void)searchButtonClicked {
    NSLog(@"%@",YHuid);
    [self searchFriendrequest];
}

- (void)searchFriendrequest{
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Search/searchFriend";
    NSDictionary *lparameters = @{@"uname":_SearchUser.text,@"uid":YHuid};
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
                  NSLog(@"%@",dict[@"data"]);
                  NSLog(@"%@",dict[@"data"][0][@"avatar"]);
                  NSLog(@"%@",dict[@"data"][0][@"uname"]);
                  NSLog(@"%@",dict[@"data"][0][@"uid"]);
                  NSLog(@"%@",dict[@"data"][0][@"status"]);
                  UIView *temp = [[UIView alloc] initWithFrame:CGRectMake( 0, 50, self.view.frame.size.width, 66)];
                  temp.backgroundColor = [UIColor colorWithRed:210/255.0 green:213/255.0 blue:218/255.0 alpha:1];
                  [self.view addSubview:temp];
                  UIImageView *addicon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 46, 46)];
                  [addicon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",dict[@"data"][0][@"avatar"]]] placeholderImage:[UIImage imageNamed:@"imfomation_icon_default"]];
                  [temp addSubview:addicon];
                  UILabel *uname = [[UILabel alloc] initWithFrame:CGRectMake(66, 10, 100, 20)];
                  [uname setFont:[UIFont boldSystemFontOfSize:12]];
                  uname.textColor = [UIColor grayColor];
                  uname.text = [[NSString alloc] initWithFormat:@"用户名:%@",dict[@"data"][0][@"uname"]];
                  [temp addSubview:uname];
                  UILabel *uid = [[UILabel alloc] initWithFrame:CGRectMake(66, 30, 100, 20)];
                  [uid setFont:[UIFont boldSystemFontOfSize:12]];
                  uid.textColor = [UIColor grayColor];
                  uid.text = [[NSString alloc] initWithFormat:@"用户编号:%@",dict[@"data"][0][@"uid"]];
                  _uid1 = dict[@"data"][0][@"uid"];
                  [temp addSubview:uid];
                  UILabel *background = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-74, 17, 64, 32)];
                  background.backgroundColor = [UIColor clearColor];
                  [background setFont:[UIFont boldSystemFontOfSize:12]];
                  background.textAlignment = NSTextAlignmentCenter;
                  [temp addSubview:background];
                  UIButton *add = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-74, 17, 64, 32)];
                  add.backgroundColor = [UIColor clearColor];
                  NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Friend/isFriend";
                  NSDictionary *parameters = @{@"uid1":YHuid,@"uid2":_uid1};
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
                                if ([_uid1 isEqualToString:YHuid]) {
                                    background.text = @"用户本人";
                                    background.textColor = [UIColor whiteColor];
                                    background.backgroundColor = [UIColor colorWithRed:210/255.0 green:213/255.0 blue:218/255.0 alpha:1];
                                }else{
                                    NSString *data = [NSString stringWithFormat:@"%@",dict[@"data"]];
                                    if ([data isEqualToString:@"1"]) {
                                        background.text = @"已是好友";
                                        background.textColor = [UIColor whiteColor];
                                        background.backgroundColor = [UIColor colorWithRed:210/255.0 green:213/255.0 blue:218/255.0 alpha:1];
                                    }else{
                                        background.text = @"添加好友";
                                        background.backgroundColor = [UIColor whiteColor];
                                        background.textColor = [UIColor grayColor];
                                        [add addTarget:self action:@selector(addfriend) forControlEvents:UIControlEventTouchUpInside];
                                    }
                                }
                            }
                            else{
                                [self presentAlert:@"数据错误"];
                            }
                        }
                        failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                            [self presentAlert:@"网络错误"];
                        }];
                  [temp addSubview:add];
              }else{
                  NSLog(@"error");
                  [self presentAlert:@"用户名不存在"];
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
          }];
}

- (void)addfriend {
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Friend/getFriend";
    NSDictionary *lparameters = @{@"uid1":YHuid,@"uid2":_uid1};
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
                  [self presentAlert:@"请求发生成功"];
              }else{
                  [self presentAlert:@"请求发送失败"];
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
          }];
}

//请勿使用
- (void)searchuser {
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Search/search";
    NSDictionary *parameters = @{@"uname":@"wute"};
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
                 NSLog(@"快点看这里！！！%@",dict);
                 NSLog(@"%@",dict[@"data"][0][@"avatar"]);
                 NSLog(@"%@",dict[@"data"][0][@"uid"]);
                 NSLog(@"%@",dict[@"data"][0][@"uname"]);
                 NSLog(@"%@",dict[@"data"][0][@"introduction"]);
                 
             }else{
                 [self presentAlert:@"没有找到相关结果"];
             }
             //[self.peopleTab reloadData];
         }
         failure:^(AFHTTPRequestOperation * operation, NSError * error) {
             [self presentAlert:@"网络错误"];
         }];
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
