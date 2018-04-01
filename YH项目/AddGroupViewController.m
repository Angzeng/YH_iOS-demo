//
//  AddGroupViewController.m
//  YH项目
//
//  Created by Apple on 2017/6/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AddGroupViewController.h"
#import "YHLoginViewController.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YHmemberMainViewController.h"

@interface AddGroupViewController ()

@property (strong , nonatomic) UISearchBar *SearchGroup;
@property (strong , nonatomic) NSString *Addstring;
@property (strong , nonatomic) UIAlertView *alert;
@property (strong , nonatomic) UIButton *searchButton;
@property (nonatomic , strong) NSString *temp;
@property (nonatomic , strong) NSString *tname;
@property (nonatomic , strong) NSString *uid1;

@end

@implementation AddGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _Addstring = nil;
    [self settitleview];
    [self setsearchview];
}

- (void)settitleview {
    self.navigationItem.title = @"添加群组";
    _SearchGroup = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-50, 50)];
    _SearchGroup.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.9 blue:79/255.0 alpha:1];
    [_SearchGroup setBarTintColor:[UIColor colorWithRed:217/255.0 green:83/255.9 blue:79/255.0 alpha:1]];
    _SearchGroup.searchBarStyle =UISearchBarStyleMinimal;
    _SearchGroup.placeholder = @"请输入查询的群组名...";
    [_SearchGroup becomeFirstResponder];
    [self.view addSubview:_SearchGroup];
}

- (void)setsearchview {
    self.view.backgroundColor = [UIColor whiteColor];
    _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 0, 50, 50)];
    _searchButton.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    [_searchButton setImage:[UIImage imageNamed:@"addgroup.png"] forState:UIControlStateNormal];
    [_searchButton addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchButton];
}

- (void)searchButtonClicked {
    NSLog(@"%@",YHuid);
    [self getuserinformation:_SearchGroup.text];
}

- (void)getuserinformation:(NSString *)targetuid{
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/Team/getTeamByName";
    NSDictionary *lparameters = @{@"name":targetuid};
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
                  NSLog(@"%@--",dict);
                  NSLog(@"%@",dict[@"data"][0][@"tname"]);
                  NSLog(@"%@",dict[@"data"][0][@"tid"]);
                  NSLog(@"%@",dict[@"data"][0][@"tavatar"]);
                  NSLog(@"%@",dict[@"data"][0][@"introduce"]);
                  NSLog(@"%@",dict[@"data"][0][@"fnd_uid"]);
                  UIView *temp = [[UIView alloc] initWithFrame:CGRectMake( 0, 50, self.view.frame.size.width, 66)];
                  temp.backgroundColor = [UIColor colorWithRed:210/255.0 green:213/255.0 blue:218/255.0 alpha:1];
                  [self.view addSubview:temp];
                  UIImageView *addicon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 46, 46)];
                  [addicon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",dict[@"data"][0][@"tavatar"]]] placeholderImage:[UIImage imageNamed:@"imfomation_icon_default"]];
                  [temp addSubview:addicon];
                  UILabel *tname = [[UILabel alloc] initWithFrame:CGRectMake(66, 10, 100, 20)];
                  [tname setFont:[UIFont boldSystemFontOfSize:12]];
                  tname.textColor = [UIColor grayColor];
                  tname.text = [[NSString alloc] initWithFormat:@"群昵称:%@",dict[@"data"][0][@"tname"]];
                  [temp addSubview:tname];
                  UILabel *intro = [[UILabel alloc] initWithFrame:CGRectMake(66, 30, 100, 20)];
                  [intro setFont:[UIFont boldSystemFontOfSize:12]];
                  intro.textColor = [UIColor grayColor];
                  intro.text = [[NSString alloc] initWithFormat:@"群介绍:%@",dict[@"data"][0][@"introduce"]];
                  _uid1 = dict[@"data"][0][@"tid"];
                  [temp addSubview:intro];
                  UILabel *background = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-74, 17, 64, 32)];
                  background.backgroundColor = [UIColor clearColor];
                  [background setFont:[UIFont boldSystemFontOfSize:12]];
                  background.textAlignment = NSTextAlignmentCenter;
                  [temp addSubview:background];
                  UIButton *add = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-74, 17, 64, 32)];
                  add.backgroundColor = [UIColor clearColor];
                  //添加群组
                  NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/TeamUser/isTeamUser";
                  NSDictionary *parameters = @{@"tid":_uid1,@"uid":YHuid};
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
                                NSString *data = [NSString stringWithFormat:@"%@",dict[@"data"]];
                                if ([data isEqualToString:@"1"]) {
                                    background.text = @"已在群组";
                                    background.textColor = [UIColor whiteColor];
                                    background.backgroundColor = [UIColor colorWithRed:210/255.0 green:213/255.0 blue:218/255.0 alpha:1];
                                }else{
                                    background.text = @"加入群组";
                                    background.backgroundColor = [UIColor whiteColor];
                                    background.textColor = [UIColor grayColor];
                                    [add addTarget:self action:@selector(AddGrouprequest) forControlEvents:UIControlEventTouchUpInside];
                                }
                            }
                            else{
                                [self presentAlert:@"数据错误"];
                            }
                        }
                        failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                            [self presentAlert:@"网络错误"];
                        }];
                  //
                  [temp addSubview:add];
              }else{
                  [self presentAlert:@"群组不存在"];
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
          }];
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

- (void)AddGrouprequest{
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/Team/getTeamInfo";
    NSDictionary *lparameters = @{@"tid":_uid1};
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
                  _tname = dict[@"data"][0][@"tname"];
                  //
                {
                  NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/TeamUser/joinTeamUser";
                  NSDictionary *lparameters = @{@"tid":_uid1,@"uid":YHuid,@"name":_tname};
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
                                [self presentAlert:@"已申请入群"];
                            }else{
                                [self presentAlert:@"加入群组失败"];
                            }
                        }
                        failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                            [self presentAlert:@"网络错误"];
                        }];
                  }
                  //
              }else{
                  [self presentAlert:@"群组不存在"];
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
          }];
    //
    
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
