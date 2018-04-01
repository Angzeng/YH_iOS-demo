//
//  GroupfndViewController.m
//  YH项目
//
//  Created by Angzeng on 26/08/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "GroupfndViewController.h"
#import "AFNetworking.h"
#import "YHmemberMainViewController.h"
#import "YHLoginViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GroupmemberlistViewController.h"
#import "changegroupiconViewController.h"

@interface GroupfndViewController ()

@property (nonatomic , strong) NSString *fnd_uid;
@property (nonatomic , strong) NSString *introduce;
@property (nonatomic , strong) NSString *tavatar;
@property (nonatomic , strong) NSString *ttitle;
@property (nonatomic , strong) UIScrollView *scrollview;
@property (nonatomic , strong) UIAlertView *alert;
@property (nonatomic , strong) UITextField *ttitleview;
@property (nonatomic , strong) UITextField *introduceview;

@end

@implementation GroupfndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getuserinformation:self.tid];
    // Do any additional setup after loading the view.
}


- (void)getuserinformation:(NSString *)targetuid{
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/Team/getTeamInfo";
    NSDictionary *lparameters = @{@"tid":targetuid};
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
                  _introduce = dict[@"data"][0][@"introduce"];
                  _tavatar = dict[@"data"][0][@"tavatar"];
                  _ttitle = dict[@"data"][0][@"tname"];
                  [self creatscrollviewUI:_introduce :_tavatar :_ttitle];
              }else{
                  NSLog(@"error");
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
          }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (![_ttitleview isExclusiveTouch]) {
        [_ttitleview endEditing:YES];
    }
    if (![_introduceview isExclusiveTouch]) {
        [_introduceview endEditing:YES];
    }
}

- (void)creatscrollviewUI:(NSString *)inintroduce :(NSString *)intavatar :(NSString *)inttitle {
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollview.contentSize = self.view.frame.size;
    _scrollview.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.view addSubview:_scrollview];
    //
    UIImageView *avatarview = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 20, 100, 100)];
    avatarview.backgroundColor = [UIColor clearColor];
    [avatarview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",_tavatar]] placeholderImage:[UIImage imageNamed:@"defaulticon"]];
    [_scrollview addSubview:avatarview];
    //
    UIButton *avatar = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 0, 100, 100)];
    avatar.backgroundColor = [UIColor clearColor];
    [avatar addTarget:self action:@selector(changeicon) forControlEvents:UIControlEventTouchUpInside];
    [_scrollview addSubview:avatar];
    //
    UITextView *first = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 150, 80, 40)];
    first.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    first.font = [UIFont boldSystemFontOfSize:14.0];
    first.text = @"群  组  名:";
    first.textColor = [UIColor darkGrayColor];
    first.editable = NO;
    first.selectable = NO;
    [_scrollview addSubview:first];
    //
    _ttitleview = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-20, 150, 120, 40)];
    _ttitleview.backgroundColor = [UIColor whiteColor];
    _ttitleview.placeholder = inttitle;
    [_scrollview addSubview:_ttitleview];
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, 120, 2)];
    lable1.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1.0];
    [_ttitleview addSubview:lable1];
    //
    UITextView *second = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 200, 80, 40)];
    second.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    second.font = [UIFont boldSystemFontOfSize:14.0];
    second.text = @"群组介绍:";
    second.textColor = [UIColor darkGrayColor];
    second.editable = NO;
    second.selectable = NO;
    [_scrollview addSubview:second];
    //
    _introduceview = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-20, 200, 120, 40)];
    _introduceview.backgroundColor = [UIColor whiteColor];
    _introduceview.placeholder = inintroduce;
    [_scrollview addSubview:_introduceview];
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, 120, 2)];
    lable2.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1.0];
    [_introduceview addSubview:lable2];
    //
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
    //
    UIButton *change = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 250, 200, 40)];
    change.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    [change setTitle: @"修改信息" forState: UIControlStateNormal];
    change.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
    [change setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [change.layer setMasksToBounds:YES];
    [change.layer setCornerRadius:10.0];
    [change.layer setBorderWidth:1.0];
    [change.layer setBorderColor:colorref];
    [change addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    [_scrollview addSubview:change];
    //
    UIButton *member = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 300, 200, 40)];
    member.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    [member setTitle: @"调整成员" forState: UIControlStateNormal];
    member.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
    [member setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [member.layer setMasksToBounds:YES];
    [member.layer setCornerRadius:10.0];
    [member.layer setBorderWidth:1.0];
    [member.layer setBorderColor:colorref];
    [member addTarget:self action:@selector(member) forControlEvents:UIControlEventTouchUpInside];
    [_scrollview addSubview:member];
    //
    UIButton *dismiss = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 350, 200, 40)];
    dismiss.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    [dismiss setTitle: @"解散群组" forState: UIControlStateNormal];
    dismiss.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
    [dismiss setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dismiss.layer setMasksToBounds:YES];
    [dismiss.layer setCornerRadius:10.0];
    [dismiss.layer setBorderWidth:1.0];
    [dismiss.layer setBorderColor:colorref];
    [dismiss addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_scrollview addSubview:dismiss];
    //
    UILabel *groupid = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 400, 200, 40)];
    groupid.text = [NSString stringWithFormat:@"群组id是:%@",self.tid];
    [groupid setFont:[UIFont boldSystemFontOfSize:13.0]];
    groupid.textAlignment = UITextAlignmentCenter;
    [_scrollview addSubview:groupid];
    
}

- (void)changeicon {
    changegroupiconViewController *changeicon = [[changegroupiconViewController alloc] init];
    changeicon.avatarurl = _tavatar;
    changeicon.tid = self.tid;
    [self.navigationController pushViewController:changeicon animated:YES];
}

- (void)change {
    if ([_introduceview.text isEqualToString:@""]) {
        _introduceview.text = [[NSString alloc] initWithString:_introduce];
    }
    if ([_ttitleview.text isEqualToString:@""]) {
        _ttitleview.text = [[NSString alloc] initWithString:_ttitle];
    }
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/Team/updateTeamInfo";
    NSLog(@"%@%@",_ttitleview.text,_introduceview.text);
    NSDictionary *lparameters = @{@"tid":self.tid,@"name":_ttitleview.text,@"introduce":_introduceview.text};
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
                  NSLog(@"%@",dict);
                  [self presentAlert:@"修改成功!"];
                  [self backaction];
              }else{
                  NSLog(@"%@",dict);
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
          }];
}

- (void)member {
    GroupmemberlistViewController *groupmemberlist = [[GroupmemberlistViewController alloc] init];
    groupmemberlist.tid = self.tid;
    groupmemberlist.tname = self.tname;
    [self.navigationController pushViewController:groupmemberlist animated:YES];
}

-(void)dismiss {
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/Team/team";
    NSDictionary *lparameters = @{@"type":@"2",@"uid":YHuid,@"tname":self.tname};
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
                  NSLog(@"%@",dict);
                  [self presentAlert:@"群组解散!"];
                  [self backaction];
              }else{
                  NSLog(@"%@",dict);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
