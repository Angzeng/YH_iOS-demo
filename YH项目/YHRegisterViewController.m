//
//  YHRegisterViewController.m
//  YHLogin
//
//  Created by Apple on 16/4/21.
//  Copyright (c) 2016年 Apple. All rights reserved.
//

#import "YHRegisterViewController.h"
#import "addtextFieldBackground.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "YHLoginViewController.h"


@interface YHRegisterViewController ()

@property (nonatomic,readonly) NSInteger screenWidth;
@property (nonatomic,readonly) NSInteger screenHeight;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UITextField *account;
@property (nonatomic,strong) UITextField *password1;
@property (nonatomic,strong) UITextField *password2;
@property (nonatomic,strong) UITextField *identifyingCode;
@property (nonatomic,strong) UIButton *getCodeButton;
@property (nonatomic,strong) UIButton *submitButton;
@property (nonatomic,strong) NSString *getAccount;
@property (nonatomic,strong) NSString *getPassword1;
@property (nonatomic,strong) NSString *getPassword2;
@property (nonatomic,strong) NSString *getIdentifyingCode;
@property (nonatomic,strong) NSString *sessionId;
@property (nonatomic,strong) UIAlertView *alert;

@end

@implementation YHRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.view.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, _screenWidth, _screenHeight - 64)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    self.navigationItem.title = @"用户注册";
    [self CreatUI];
    // Do any additional setup after loading the view.
}

- (void)CreatUI{
    CGFloat sep = 30;
    CGFloat h = 44;
    UIImageView *imgView;
    
    _account = [[UITextField alloc] initWithFrame:CGRectMake(sep,_bgView.frame.origin.y + sep, _screenWidth - 2*sep, h)];
    _account.backgroundColor = [UIColor whiteColor];
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _account.frame.size.height, _account.frame.size.height)];
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
    [self.view addSubview:_account];
    
    _password1 = [[UITextField alloc] initWithFrame:CGRectMake(_account.frame.origin.x,_account.frame.origin.y+_account.frame.size.height+sep, _account.frame.size.width, _account.frame.size.height)];
    _password1.backgroundColor = [UIColor whiteColor];
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _password1.frame.size.height, _password1.frame.size.height)];
    imgView.image = [UIImage imageNamed:@"username"];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    _password1.leftView = imgView;
    _password1.leftViewMode = UITextFieldViewModeAlways;
    _password1.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password1.layer.cornerRadius = 4.0;
    _password1.layer.borderWidth = 1.0;
    _password1.layer.borderColor = [[UIColor brownColor] CGColor];
    _password1.placeholder = @"请输入密码(8-20位数字、字母)";
    _password1.secureTextEntry = YES;
    [self.view addSubview:_password1];
    
    _password2 = [[UITextField alloc] initWithFrame:CGRectMake(_password1.frame.origin.x,_password1.frame.origin.y+_password1.frame.size.height+sep, _password1.frame.size.width, _password1.frame.size.height)];
    _password2.backgroundColor = [UIColor whiteColor];
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _password2.frame.size.height, _password2.frame.size.height)];
    imgView.image = [UIImage imageNamed:@"username"];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    _password2.leftView = imgView;
    _password2.leftViewMode = UITextFieldViewModeAlways;
    _password2.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password2.layer.cornerRadius = 4.0;
    _password2.layer.borderWidth = 1.0;
    _password2.layer.borderColor = [[UIColor brownColor] CGColor];
    _password2.placeholder = @"请再次输入密码";
    _password2.secureTextEntry = YES;
    [self.view addSubview:_password2];
    
    _identifyingCode = [[UITextField alloc] initWithFrame:CGRectMake(_password2.frame.origin.x,_password2.frame.origin.y+_password2.frame.size.height+sep, _password2.frame.size.width - 2*h - sep, _password2.frame.size.height)];
    _identifyingCode.backgroundColor = [UIColor whiteColor];
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _identifyingCode.frame.size.height, _identifyingCode.frame.size.height)];
    imgView.image = [UIImage imageNamed:@"username"];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    _identifyingCode.leftView = imgView;
    _identifyingCode.leftViewMode = UITextFieldViewModeAlways;
    _identifyingCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    _identifyingCode.layer.cornerRadius = 4.0;
    _identifyingCode.layer.borderWidth = 1.0;
    _identifyingCode.layer.borderColor = [[UIColor brownColor] CGColor];
    _identifyingCode.placeholder = @"请输入验证码";
    [self.view addSubview:_identifyingCode];
    
    _getCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getCodeButton setFrame:CGRectMake(_screenWidth - sep, _identifyingCode.frame.origin.y, -2*h - sep/2, _identifyingCode.frame.size.height)];
    _getCodeButton.layer.cornerRadius=5.0;
    [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getCodeButton.titleLabel setFont:[UIFont systemFontOfSize: 16.0]];
    [_getCodeButton setBackgroundColor:[UIColor colorWithRed:149/255.0 green:133/255.0 blue:71/255.0 alpha:1]];
    [_getCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_getCodeButton addTarget:self action:@selector(getIdCode) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_getCodeButton];
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_submitButton setFrame:CGRectMake(_screenWidth/2-3*h, _identifyingCode.frame.origin.y+_identifyingCode.frame.size.height+2*sep, 6*h, h)];
    _submitButton.layer.cornerRadius=5.0;
    [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
    [_submitButton.titleLabel setFont:[UIFont systemFontOfSize: 20.0]];
    [_submitButton setBackgroundColor:[UIColor colorWithRed:149/255.0 green:133/255.0 blue:71/255.0 alpha:1]];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_submitButton];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //回收键盘
    [self.view endEditing:YES];
}

-(void)openCountdown{
    __block NSInteger time = 119; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                [_getCodeButton setBackgroundColor:[UIColor colorWithRed:149/255.0 green:133/255.0 blue:71/255.0 alpha:1]];
                _getCodeButton.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 120;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [_getCodeButton setTitle:[NSString stringWithFormat:@"%.2ds", seconds] forState:UIControlStateNormal];
                [_getCodeButton setBackgroundColor:[UIColor grayColor]];
                _getCodeButton.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

- (BOOL)checkPhone:(NSString *)phoneNumber{
    NSString *pattern = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    return !isMatch;
}

- (BOOL)checkPassword:(NSString *) password{
    NSString *pattern =@"^[a-zA-Z0-9]{8,20}+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return !isMatch;
}

- (BOOL)checkIdCode:(NSString *) code{
    NSString *pattern =@"^[0-9]{4,6}+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:code];
    return !isMatch;
}

- (void)getIdCode{
    _getAccount = _account.text;
    if(_getAccount.length == 0){
        [self presentAlert:4];
        return;
    }else if ([self checkPhone:_getAccount]){
        [self presentAlert:5];
        return;
    }
    [self openCountdown];
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/SMS/sendSMS";
    NSDictionary *parameters = @{@"id":@"0",@"phone":_getAccount};
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
                  [self presentAlert:11];
                  _sessionId = [NSString stringWithFormat:@"%@",dict[@"data"][@"sessionId"]];
              }else{
                  [self presentAlert:12];
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              [self presentAlert:2];
          }];
}

- (void) submit{
    _getAccount = _account.text;
    _getPassword1 = _password1.text;
    _getPassword2 = _password2.text;
    _getIdentifyingCode = _identifyingCode.text;
    
    if(_getAccount.length == 0){
        [self presentAlert:4];
        return;
    }
    if ([self checkPhone:_getAccount]){
        [self presentAlert:5];
        return;
    }
    if(_getPassword1.length == 0){
        [self presentAlert:6];
        return;
    }
    if ([self checkPassword:_getPassword1]){
        [self presentAlert:7];
        return;
    }
    if (![_getPassword1 isEqualToString:_getPassword2]) {
        [self presentAlert:8];
        return;
    }
    if (_getIdentifyingCode.length == 0) {
        [self presentAlert:9];
        return;
    }
    if ([self checkIdCode:_getIdentifyingCode]){
        [self presentAlert:10];
        return;
    }
    if (_sessionId.length == 0) {
        [self presentAlert:14];
        return;
    }
    
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Register/register";
    NSDictionary *parameters = @{@"type":@"0",@"mobile":_getAccount,@"password":_getPassword1,@"sessionid":_sessionId,@"phonecode":_getIdentifyingCode};
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
                  [userDefaults setObject:@"useraccount" forKey:_getAccount];
                  [userDefaults setObject:@"userpassword" forKey:_getPassword1];
                  [self.navigationController popViewControllerAnimated:YES];
              }else if([code isEqualToString:@"405"]){
                  [self presentAlert:3];
              }else if ([code isEqualToString:@"408"]){
                  [self presentAlert:13];
              }else{
                  [self presentAlert:1];
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              [self presentAlert:2];
          }];
}

-(void) presentAlert:(NSInteger)type{
    NSString *alert = @"";
    switch (type) {
        case 0:
            alert = @"注册成功";
            break;
        case 1:
            alert = @"注册失败";
            break;
        case 2:
            alert = @"网络错误";
            break;
        case 3:
            alert = @"验证码错误";
            break;
        case 4:
            alert = @"请输入手机号";
            break;
        case 5:
            alert = @"手机号格式错误";
            break;
        case 6:
            alert = @"请输入密码";
            break;
        case 7:
            alert = @"密码格式错误";
            break;
        case 8:
            alert = @"两次密码不相同";
            break;
        case 9:
            alert = @"请输入验证码";
            break;
        case 10:
            alert = @"验证码格式错误";
            break;
        case 11:
            alert = @"验证码发送成功";
            break;
        case 12:
            alert = @"验证码发送失败";
            break;
        case 13:
            alert = @"手机号已经被注册";
            break;
        case 14:
            alert = @"请获取验证码";
            break;
        default:
            break;
    }
    if ([alert isEqualToString:@""]) {
        return;
    }
    //设置alert时间响应
    _alert=[[UIAlertView alloc]initWithTitle:alert message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
    [_alert show];
}

-(void) performDismiss:(NSTimer *)timer{
    [_alert dismissWithClickedButtonIndex:0 animated:NO];
    //    [_registeralert release];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)registerButtonClick{
//    //NSString *message = nil;
//    //得到用户名和密码
//    NSString *registeraccount=self.registeraccount.text;
//    NSString *registerpassword=self.registerpassword.text;
//    NSString *registerrepassword=self.registerrepassword.text;
//    //判断输入数据
//    if(self.registeraccount.text.length==0){
//        _registeralert=[[UIAlertView alloc]initWithTitle:@"注册手机号不能为空" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
//        [_registeralert show];
//        return;
//    }
//    if(self.registeraccount.text.length!=11){
//        _registeralert=[[UIAlertView alloc]initWithTitle:@"请重新输入注册手机号" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
//        [_registeralert show];
//        return;
//    }
//    if(self.registerpassword.text.length==0){
//        _registeralert=[[UIAlertView alloc]initWithTitle:@"注册密码不能为空" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
//        [_registeralert show];
//        return;
//    }
//    if(self.registerpassword.text.length<6){
//        _registeralert=[[UIAlertView alloc]initWithTitle:@"注册密码至少为六位数" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
//        [_registeralert show];
//        return;
//    }
//    if(self.registerrepassword.text.length==0){
//        _registeralert=[[UIAlertView alloc]initWithTitle:@"再次输入的注册密码不能为空" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
//        [_registeralert show];
//        return;
//    }
//    if(![self.registerrepassword.text isEqualToString: self.registerpassword.text]){
//        _registeralert=[[UIAlertView alloc]initWithTitle:@"两次输入的密码不匹配" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
//        [_registeralert show];
//        return;
//    }
//
//    /*＃---URL请求部分---*/
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    //申明返回的结果是json类型
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    //申明请求的数据是json类型
//    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
//    //    //如果报接受类型不一致请替换一致text/html或别的
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    //传入的参数
//    NSDictionary *parameters = @{@"mobile":registeraccount,@"password":registerpassword};
//    //你的接口地址
//    NSString *url=@"http://zhujinchi.com/index.php/Mobile/Register/register";
//    
//    //发送请求
//    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [[serverManager sharedManager]registerWithName:registeraccount password:registerpassword];
//        NSString *html = operation.responseString;
//        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
//        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
//        NSString *acd=dict[@"code"];
//        int abc = [acd intValue];
//        //
//        //NSLog(@"%@",acd);
//        //NSLog(@"%d",abc);
//        //
//        if (abc==200) {
//
//            [self presentsuccessAlert];
//            [self dismissViewControllerAnimated:YES completion:^{}];
//        }else{
//            _registeralert=[[UIAlertView alloc]initWithTitle:@"用户名已被注册" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//            [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
//            [_registeralert show];
//        }
//
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        _registeralert=[[UIAlertView alloc]initWithTitle:@"请检查网络连接" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
//        [_registeralert show];
//    }];
//}
//
//
//-(void) presentsuccessAlert{
//    //设置alert时间响应
//    _registeralert=[[UIAlertView alloc]initWithTitle:@"注册成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
//    [_registeralert show];
//}
//
//-(void) presentfailAlert{
//    //设置alert时间响应
//    _registeralert=[[UIAlertView alloc]initWithTitle:@"注册失败" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
//    [_registeralert show];
//}

@end
