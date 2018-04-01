//
//  YHLoginViewController.m
//  YHLogin
//
//  Created by Apple on 16/4/21.
//  Copyright (c) 2016年 Apple. All rights reserved.
//

#import "AppDelegate.h"
#import "YHLoginViewController.h"
#import "textFieldBackground.h"
#import "YHRegisterViewController.h"
#import "YHResetPasswordViewController.h"
#import "YHQuestionViewController.h"
#import "YHTabBarController.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <MJExtension/MJExtension.h>
#import <CommonCrypto/CommonDigest.h>

@interface YHLoginViewController ()

@property (nonatomic,readonly) NSInteger screenWidth;
@property (nonatomic,readonly) NSInteger screenHeight;
@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,strong) UITextField *account;
@property (nonatomic,strong) UITextField *password;
@property (nonatomic,strong) UIButton *loginButton;
@property (nonatomic,strong) UILabel *resetPassword;
@property (nonatomic,strong) UILabel *userRegister;
@property (nonatomic,strong) UIVisualEffectView *effectView;
@property (nonatomic,strong) UIAlertView *loginAlert;
@property (nonatomic,strong) NSString *getAccount;
@property (nonatomic,strong) NSString *getPassword;
@property (nonatomic,readwrite) Boolean isLogin;
@property (nonatomic,strong) NSString *questioncount;

@end

NSString *YHtemp;
NSString *YHuid;
NSString *YHuname;
NSArray *YHCapacityOfUser;
NSString *YHjwt;

@implementation YHLoginViewController

NSMutableData *totalData;


- (void)viewDidLoad {
    [super viewDidLoad];
    _isLogin = false;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mapfinal"]];
    [_backgroundImageView setFrame:CGRectMake(0, 0, _screenWidth, _screenHeight)];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_backgroundImageView];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(CreateUI) userInfo:nil repeats:NO];
}

- (void)CreateUI{
 
    CGFloat sep = 30;
    CGFloat h = 44;
    //毛玻璃视图
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];;
    _effectView.frame = CGRectMake(0, 0, _screenWidth, _screenHeight);
    [self.backgroundImageView addSubview:_effectView];
    
    _account = [[UITextField alloc] initWithFrame:CGRectMake(sep,(_screenHeight-sep)/2, _screenWidth - 2*sep, -h)];
    _account.backgroundColor = [UIColor whiteColor];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _account.frame.size.height, _account.frame.size.height)];
    imgView.image = [UIImage imageNamed:@"username"];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    _account.leftView = imgView;
    _account.leftViewMode = UITextFieldViewModeAlways;
    _account.clearButtonMode = UITextFieldViewModeWhileEditing;
    _account.keyboardType = UIKeyboardTypePhonePad;
    _account.layer.cornerRadius = 4.0;
    _account.layer.borderWidth = 1.0;
    _account.layer.borderColor = [[UIColor brownColor] CGColor];
    _account.placeholder = @"请输入手机号";
    _account.alpha = 0.0;
    [self.view addSubview:_account];
    
    _password = [[UITextField alloc] initWithFrame:CGRectMake(_account.frame.origin.x,_account.frame.origin.y+_account.frame.size.height+sep, _account.frame.size.width, _account.frame.size.height)];
    _password.backgroundColor = [UIColor whiteColor];
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _password.frame.size.height, _password.frame.size.height)];
    imgView1.image = [UIImage imageNamed:@"username"];
    imgView1.contentMode = UIViewContentModeScaleAspectFit;
    _password.leftView = imgView1;
    _password.leftViewMode = UITextFieldViewModeAlways;
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password.layer.cornerRadius = 4.0;
    _password.layer.borderWidth = 1.0;
    _password.layer.borderColor = [[UIColor brownColor] CGColor];
    _password.placeholder = @"请输入密码";
    _password.secureTextEntry = YES;
    _password.alpha = 0.0;
    [self.view addSubview:_password];
    _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_loginButton setFrame:CGRectMake(_screenWidth/2-h, _password.frame.origin.y+_password.frame.size.height+sep, 2*h, h)];
    _loginButton.layer.cornerRadius=5.0;
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setBackgroundColor:[UIColor colorWithRed:149/255.0 green:133/255.0 blue:71/255.0 alpha:1]];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
    _loginButton.alpha = 0.0;
    [self.view addSubview:_loginButton];
    
    _resetPassword = [[UILabel alloc]initWithFrame:CGRectMake(sep, _screenHeight-64, 2*h, -h)];
    _resetPassword.text = @"忘记密码？";
    _resetPassword.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14.0f];;
    _resetPassword.backgroundColor = [UIColor clearColor];
    _resetPassword.textAlignment = NSTextAlignmentCenter;
    _resetPassword.userInteractionEnabled = YES;
    [_resetPassword addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetPassword:)]];
    _resetPassword.alpha = 0.0;
    [self.view addSubview:_resetPassword];
    
    _userRegister = [[UILabel alloc]initWithFrame:CGRectMake(_screenWidth-sep, _screenHeight-64, -2*h, -h)];
    _userRegister.text = @"新用户注册";
    _userRegister.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14.0f];;
    _userRegister.backgroundColor = [UIColor clearColor];
    _userRegister.textAlignment = NSTextAlignmentCenter;
    _userRegister.userInteractionEnabled = YES;
    [_userRegister addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Register:)]];
    _userRegister.alpha = 0.0;
    [self.view addSubview:_userRegister];
    
    //
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *defaultAccount = [ user objectForKey:@"useraccount"];
    NSString *defaultpassWord = [ user objectForKey:@"userpassword"];
    if(defaultAccount){
        _account.text = defaultAccount;
    }
    if(defaultpassWord){
        _password.text = defaultpassWord;
    }
    //
    
    [UIView animateWithDuration:1.0 animations:^{
        _effectView.alpha = 1.0;
        _account.alpha = 1.0;
        _password.alpha = 1.0;
        _loginButton.alpha = 1.0;
        _resetPassword.alpha = 1.0;
        _userRegister.alpha = 1.0;
    }];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //回收键盘
    [self.view endEditing:YES];
}

- (void)Register:(UIGestureRecognizer *) sender{
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    YHRegisterViewController *Register = [[YHRegisterViewController alloc] init];
    [self.navigationController pushViewController:Register animated:YES];
}

- (void)resetPassword:(UIGestureRecognizer *) sender{
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    YHResetPasswordViewController *reset = [[YHResetPasswordViewController alloc] init];
    [self.navigationController pushViewController:reset animated:YES];
}

- (BOOL)checkPhone:(NSString *)phoneNumber{
    NSString *pattern = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    return !isMatch;
}

- (BOOL)checkPassword:(NSString *) password{
    NSString *pattern =@"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return !isMatch;
}

- (void)login{
    if (_isLogin) {
        return;
    }
    _getAccount = _account.text;
    _getPassword = _password.text;
    if(_getAccount.length==0){
        [self presentAlert:3];
        return;
    }
    if([self checkPhone:_getAccount]){
        [self presentAlert:4];
        return;
    }
    if(_getPassword.length==0){
        [self presentAlert:5];
        return;
    }
    if([self checkPassword:_getPassword]){
        [self presentAlert:6];
        return;
    }
    _isLogin = true;
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Login/login";
    NSDictionary *parameters = @{@"type":@"0",@"mobile":_getAccount,@"password":[self MD5enc:_getPassword With:_getAccount]};
    
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
                  [self presentAlert:0];
                  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                  [userDefaults setObject:_getAccount forKey:@"useraccount"];
                  [userDefaults setObject:_getPassword forKey:@"userpassword"];
                  extern NSString *YHuid;
                  extern NSString *YHuname;
                  extern NSArray *YHCapacityOfUser;
                  extern NSString *YHjwt;
                  //登录新建全局数据
                  YHuid = dict[@"data"][0][@"uid"];
                  YHuname = dict[@"data"][0][@"uname"];
                  YHCapacityOfUser = nil;
                  YHjwt = dict[@"data"][0][@"jwt"];
                  [self signIn];
              }else{
                  _isLogin = false;
                  [self presentAlert:1];
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              _isLogin = false;
              [self presentAlert:2];
          }];
}

- (void)signIn{
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/SignIn/signIn";
    NSDictionary *lparameters = @{@"uid":YHuid};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置回复内容信息
    [manager.requestSerializer setValue:YHjwt forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager GET:urlStr
      parameters:lparameters//请求参数
         success:^(AFHTTPRequestOperation * operation, id responseObject){
             _isLogin = false;
             NSString *html = operation.responseString;
             NSData* data = [html dataUsingEncoding:NSUTF8StringEncoding];
             id dict = [NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
             NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
             //答题登录修改点
             if ([code isEqualToString:@"200"]) {
                 YHQuestionViewController *next1 = [[YHQuestionViewController alloc] init];
                 //
                 NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Feature/feature";
                 NSDictionary *parameters = @{@"type":@"1",@"uid":YHuid,@"muid":YHuid};
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
                               _questioncount = dict[@"data"][@"question_count"];
                               next1.islastone = _questioncount;
                               [self.navigationController pushViewController: next1 animated:YES];
                           }
                       }
                       failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                       }];
             }else{
                 YHTabBarController *next = [[YHTabBarController alloc] init];
                 [self presentViewController:next animated:YES completion:nil];
             }
         }
         failure:^(AFHTTPRequestOperation * operation, NSError * error) {
             _isLogin = false;
             [self presentAlert:2];
         }];
}

-(void) presentAlert:(NSInteger)type{
    NSString *alert = @"";
    switch (type) {
        case 0:
            alert = @"登录成功";
            break;
        case 1:
            alert = @"登录失败";
            break;
        case 2:
            alert = @"网络错误";
            break;
        case 3:
            alert = @"请输入手机号";
            break;
        case 4:
            alert = @"手机号格式错误";
            break;
        case 5:
            alert = @"请输入密码";
            break;
        case 6:
            alert = @"密码格式错误";
            break;

        default:
            break;
    }
    //设置alert时间响应
    if ([alert isEqualToString:@""]) {
        return;
    }
    _loginAlert=[[UIAlertView alloc]initWithTitle:alert message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
    [_loginAlert show];
}

- (NSString *) MD5enc:(NSString *) secret With:(NSString *)salt{
    secret = [self md5:[NSString stringWithFormat:@"%@%@",secret,salt]];
    salt = [self md5:[NSString stringWithFormat:@"%@%@",secret,salt]];
    secret = [self md5:[NSString stringWithFormat:@"%@%@yinghui",secret,salt]];
    return secret;
}

- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

- (void) SetUserAccount:(NSString *)uaccount :(NSString *)upassword {
    NSString *Account = uaccount;
    NSUserDefaults *usera = [NSUserDefaults standardUserDefaults];
    [usera setObject:Account forKey:@"userAccount"];
    NSString *passWord = upassword;
    NSUserDefaults *userp = [NSUserDefaults standardUserDefaults];
    [userp setObject:passWord forKey:@"userPassWord"];
}

-(void) performDismiss:(NSTimer *)timer
{
    [_loginAlert dismissWithClickedButtonIndex:0 animated:NO];
    //    [_registeralert release];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
