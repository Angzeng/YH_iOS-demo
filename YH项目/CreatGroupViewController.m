//
//  CreatGroupViewController.m
//  YH项目
//
//  Created by Apple on 2017/6/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CreatGroupViewController.h"
#import "AFNetworking.h"
#import "YHLoginViewController.h"
#import "YHmemberMainViewController.h"

@interface CreatGroupViewController ()

@property (strong , nonatomic) UIScrollView *Mainview;
@property (strong , nonatomic) UIImageView *picture;
@property (strong , nonatomic) UITextField *Groupname;
@property (strong , nonatomic) UITextField *Groupintroduction;
@property (strong , nonatomic) UIButton *post;
@property (nonatomic , strong) UIAlertView *alert;

@end

@implementation CreatGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创建群组";
    [self creatUI];
}

- (void)creatUI {
    self.view.backgroundColor = [UIColor whiteColor];
    _Mainview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _Mainview.contentSize = self.view.frame.size;
    [self.view addSubview:_Mainview];
    //
    _picture = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-66, 10, 132, 132)];
    _picture.image = [UIImage imageNamed:@"logo"];
    [_Mainview addSubview:_picture];
    //
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-140, 152, 66, 32)];
    label1.backgroundColor = [UIColor lightGrayColor];
    label1.text = @"群昵称";
    [label1 setFont:[UIFont boldSystemFontOfSize:13]];
    [label1 setTextColor:[UIColor whiteColor]];
    label1.textAlignment = NSTextAlignmentCenter;
    [_Mainview addSubview:label1];
    //
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-140, 194, 66, 32)];
    label2.backgroundColor = [UIColor lightGrayColor];
    label2.text = @"群介绍";
    [label2 setFont:[UIFont boldSystemFontOfSize:13]];
    [label2 setTextColor:[UIColor whiteColor]];
    label2.textAlignment = NSTextAlignmentCenter;
    [_Mainview addSubview:label2];
    //
    _Groupname = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-140+66, 152, 214, 32)];
    NSString *holderText = @"请输入群昵称";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:0.5]
                        range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:13]
                        range:NSMakeRange(0, holderText.length)];
    _Groupname.attributedPlaceholder = placeholder;
    [_Mainview addSubview:_Groupname];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-140+66, 182, 214, 2)];
    label3.backgroundColor = [UIColor darkGrayColor];
    [_Mainview addSubview:label3];
    //
    _Groupintroduction = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-140+66, 194, 214, 32)];
    NSString *holderText2 = @"请输入群介绍...";
    NSMutableAttributedString *placeholder2 = [[NSMutableAttributedString alloc] initWithString:holderText2];
    [placeholder2 addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:0.5]
                        range:NSMakeRange(0, holderText.length)];
    [placeholder2 addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:13]
                        range:NSMakeRange(0, holderText.length)];
    _Groupintroduction.attributedPlaceholder = placeholder2;
    [_Mainview addSubview:_Groupintroduction];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-140+66, 224, 214, 2)];
    label4.backgroundColor = [UIColor darkGrayColor];
    [_Mainview addSubview:label4];
    //
    //
    _post = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-120)/2, 264, 120, 40)];
    _post.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    [_post setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_post setTitle:@"创建群组" forState:UIControlStateNormal];
    [_post addTarget:self action:@selector(postbuttonclicked) forControlEvents:UIControlEventTouchUpInside];
    [_Mainview addSubview:_post];
}

- (void)postbuttonclicked {
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Team/createTeam";
    NSDictionary *lparameters = @{@"uid":YHuid,@"name":_Groupname.text,@"introduce":_Groupintroduction.text};
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
                  NSLog(@"%@",dict);
                  [self presentAlert:@"群组创建成功"];
                  [self backaction];
              }else{
                  NSLog(@"error");
                  [self presentAlert:@"群组创建失败"];
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
