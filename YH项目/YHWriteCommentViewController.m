//
//  WriteTextViewController.m
//  JH项目
//
//  Created by zhujinchi on 15/12/2.
//  Copyright © 2015年 Apple. All rights reserved.
//
#import "YHWriteCommentViewController.h"
#import "AFNetworking.h"
#import "YHLoginViewController.h"
#import "YHCommentViewController.h"

@interface YHWriteCommentViewController()

@property (strong, nonatomic)  UILabel *topLabel;//最上面标签 显示字数
@property (strong, nonatomic)  UIButton *leftButton;//返回按钮
@property (strong, nonatomic)  UIButton *rightButton; //插图图片按钮
@property (strong, nonatomic)  UITextView *textView;   //文本输入框
@property (nonatomic,strong) UIAlertView *alert;

 
@end

@implementation YHWriteCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _screenWidth = [UIScreen mainScreen].bounds.size.width;//获取屏幕尺寸
    _isSubmitting = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"评 论";
    self.tabBarController.tabBar.hidden = YES;  //隐藏tabbar
    [self setupText];  //以下依次启动控件
    [self setupTopLabel];
    [self setupLeftButton];
    [self setupRightButton];
    //[self setupSubmit];
    [self.textView becomeFirstResponder];
    //

}

-(void)setupText{//文本输入框
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10,60,_screenWidth-20,200)];
    //    _textView.layer.borderColor=[UIColor grayColor].CGColor;  //边框显示
    //    _textView.layer.borderWidth=1.0;
    //    _textView.layer.cornerRadius=5.0;
    _textView.font = [UIFont fontWithName:@"Arial" size:17.0f];
    _textView.textColor = [UIColor blackColor];
    self.textView.delegate = self;
    [self calculateAndDisplayTextViewLengthWithText:self.textView.text];
    [self.view addSubview:_textView];
}
-(void)setupTopLabel{  //最上面标签 显示字数
    _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(70.0f,10.0f,_screenWidth-140,50.0f)];
    _topLabel.font=[UIFont boldSystemFontOfSize:20];
    _topLabel.textAlignment = NSTextAlignmentCenter;
    _topLabel.textColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    _topLabel.text = @"0 / 50";
    [self.view addSubview:_topLabel];
    
}

-(void)setupLeftButton{ //返回按钮
    _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(10,10, 50, 50)];
    [_leftButton setImage:[UIImage imageNamed:@"passagecenter_deny"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_leftButton];
}
-(void)back{    //返回时调用
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupRightButton{  //提交按钮
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(_screenWidth-60,10, 50, 50)];
    [_rightButton setImage:[UIImage imageNamed:@"passagecenter_up"] forState:UIControlStateNormal];
    //[_rightButton addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchDown];
    [_rightButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_rightButton];
}

//-(void)setupSubmit{  //提交按钮
//    UIButton * submitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//    [submitButton setImage:[UIImage imageNamed:@"passagecenter_up"] forState:UIControlStateNormal];
//    [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchDown];
//    //这里添加上传事件响应
//    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithCustomView:submitButton];
//    self.navigationItem.rightBarButtonItem=rightItem;
//}
-(void)submit{
    if (![self isBlankString:_textView.text]){
        [self submitComment];
    }
}

- (void)submitComment{
    if (_isSubmitting) {
        return;
    }else{
        _isSubmitting = YES;
    }
    if (_textView.text.length == 0 ) {
        _alert=[[UIAlertView alloc]initWithTitle:@"请输入评论" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
        [_alert show];
    }
    if (_textView.text.length > 50) {
        _alert=[[UIAlertView alloc]initWithTitle:@"内容字数超标" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
        [_alert show];
    }
    if (_textView.text.length > 0 && _textView.text.length <= 50){
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Comment/comment";
    NSDictionary *parameters = @{@"type":@1,@"uid":YHuid,@"aid":_aid,@"info":self.textView.text};
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
                 [self.navigationController popViewControllerAnimated:YES];
             }else{
                 [self presentAlert:@"提交失败"];
             }
         }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              [self presentAlert:@"网络错误"];
          }];
    }
    _isSubmitting = NO;
}

-(void)calculateAndDisplayTextViewLengthWithText:(NSString *)paramText{//计算字数
    NSString *characterOrCharacters = @" / 50";
    if([paramText length] == 1){
        characterOrCharacters = @" / 50";
    }
    if ([paramText length]>50) {
        self.topLabel.textColor=[UIColor redColor];
    }
    else
        self.topLabel.textColor=[UIColor blackColor];
    self.topLabel.text = [NSString stringWithFormat:@"%lu%@",(unsigned long)[paramText length],characterOrCharacters];
}

//限制输入类型 暂无限制
-(BOOL)textView:(UITextView *)textView shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL result = YES;
    if([textView isEqual:self.textView]){
        NSString *wholeText = [textView.text stringByReplacingCharactersInRange:range withString:string];
        [self calculateAndDisplayTextViewLengthWithText:wholeText];
    }
    return result;
}


-(BOOL)textViewShouldReturn:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

-(void)textViewDidChange:(UITextView*)textView{ //文本改变时调用
    [self calculateAndDisplayTextViewLengthWithText:self.textView.text];
}

- (void)viewWillAppear:(BOOL)animated//监听事件 监听键盘
{
    //注册通知,监听键盘出现
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidShow:)
                                                name:UIKeyboardDidShowNotification
                                              object:nil];
    //注册通知，监听键盘消失事件
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidHidden)
                                                name:UIKeyboardDidHideNotification
                                              object:nil];
    [super viewWillAppear:YES];
}


//监听事件
- (void)handleKeyboardDidShow:(NSNotification*)paramNotification
{
    //获取键盘高度
    NSValue *keyboardRectAsObject=[[paramNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    [keyboardRectAsObject getValue:&keyboardRect];
    
    self.textView.contentInset=UIEdgeInsetsMake(0, 0,80, 0);
}

- (void)handleKeyboardDidHidden //键盘已经隐藏
{
    self.textView.contentInset=UIEdgeInsetsZero;
}

- (void)viewDidDisappear:(BOOL)animated//键盘已经消失
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{  //点击空白区域 键盘消失
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
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

@end
