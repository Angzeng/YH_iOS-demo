//
//  WriteTitleViewController.m
//  JH项目
//
//  Created by zhujinchi on 15/12/2.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YHWriteTitleViewController.h"
#import "YHWriteTextViewController.h"
#import "YHArticlesCenterViewController.h"

@interface YHWriteTitleViewController ()

@property (strong, nonatomic) UITextField *titleview;//文字输入框
@property (strong, nonatomic) UILabel *topLabel;//上标签
@property (strong, nonatomic) UIButton *leftButton;//左按钮
@property (strong, nonatomic) UIButton *rightButton;//右按钮
@property (nonatomic,strong) UIAlertView *titlealert;

@end

NSString *YHarticletitle;

@implementation YHWriteTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _screenWidth = [UIScreen mainScreen].bounds.size.width;//获取屏幕大小
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.view.backgroundColor = [UIColor whiteColor];//背景色
    self.navigationItem.title = @"标 题";   //标题
    self.tabBarController.tabBar.hidden = YES; //隐藏tabbar
    [self setupField];                //一下依次启动控件
    [self setupTopLabel];
    [self setupLeftButton];
    [self setupRightButton];
    [self calculateAndDisplayTextFieldLengthWithText:self.titleview.text];
    [self.titleview becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

-(void)setupField{
    CGRect fieldFrame = CGRectMake(20,70,_screenWidth-40,30);
    if (_screenHeight <= 480) {
        fieldFrame = CGRectMake(20,70,_screenWidth-40,30);
    }
    _titleview = [[UITextField alloc]initWithFrame:fieldFrame];
    _titleview.backgroundColor = [UIColor whiteColor];
    _titleview.font = [UIFont fontWithName:@"Arial" size:17.0f];
    _titleview.textColor = [UIColor blackColor];;
    _titleview.clearButtonMode = UITextFieldViewModeAlways;
    _titleview.placeholder = @"请输入您的标题（限30个字）";
    _titleview.textAlignment = NSTextAlignmentLeft;
    _titleview.returnKeyType = UIReturnKeyDone;
    //    _titleview.layer.borderColor = [UIColor grayColor].CGColor;
    //    _titleview.layer.borderWidth=1.0;
    //    _titleview.layer.cornerRadius=5.0;
    [_titleview addTarget:self action:@selector(textFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
    _titleview.delegate = self;//代理
    [self.view addSubview:_titleview];
}
-(void)setupTopLabel{
    CGRect topLabelFrame = CGRectMake(70.0f,10.0f,_screenWidth-140,50.0f);
    self.topLabel = [ [UILabel alloc]initWithFrame:topLabelFrame];
    //    self.topLabel.backgroundColor=[UIColor grayColor];
    self.topLabel.font=[UIFont boldSystemFontOfSize:20];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.textColor = [UIColor blackColor];
    self.topLabel.text = @"0 / 30";
    [self.view addSubview:self.topLabel];
    
}

-(void)setupLeftButton{
    _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(10,10, 50, 50)];
    [_leftButton setImage:[UIImage imageNamed:@"passagecenter_deny"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    //    _leftButton.backgroundColor=[UIColor redColor];
    [self.view addSubview:_leftButton];
}

-(void)back{          //返回时调用
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupRightButton{
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(_screenWidth-60,10, 50, 50)];
    [_rightButton setImage:[UIImage imageNamed:@"passagecenter_upto"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(buttonRight) forControlEvents:UIControlEventTouchDown];
    //    _rightButton.backgroundColor=[UIColor redColor];
    [self.view addSubview:_rightButton];
}
- (void)buttonRight{   //进入正文界面调用
    
    if (_titleview.text.length == 0 ) {
        _titlealert=[[UIAlertView alloc]initWithTitle:@"请输入标题" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
        [_titlealert show];
    }
    if (_titleview.text.length > 30) {
        _titlealert=[[UIAlertView alloc]initWithTitle:@"标题字数超标" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
        [_titlealert show];
    }
    if (_titleview.text.length > 0 && _titleview.text.length <= 30) {
        //
        YHarticletitle = _titleview.text;
        //
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithTitle:@"文章" style:UIBarButtonItemStyleDone target:self action:nil];
        self.navigationItem.backBarButtonItem=backItem;
        YHWriteTextViewController *write1 = [[YHWriteTextViewController alloc] init];
        [self.navigationController pushViewController:write1 animated:YES];
    }

}

-(void)calculateAndDisplayTextFieldLengthWithText:(NSString *)paramText{ //计算字数
    NSString *characterOrCharacters = @"/ 30";
    if([paramText length] == 1){
        characterOrCharacters = @"/ 30";
    }
    if ([paramText length]>12) {
        self.topLabel.textColor=[UIColor redColor];
    }
    else{
        self.topLabel.textColor=[UIColor blackColor];
    }
    self.topLabel.text = [NSString stringWithFormat:@"%lu %@",(unsigned long)[paramText length],characterOrCharacters];
}

-(void) performDismiss:(NSTimer *)timer
{
    [_titlealert dismissWithClickedButtonIndex:0 animated:NO];
    //    [_registeralert release];
}

//对输入内容做出限制 暂时没有限制
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL result = YES;
    if([textField isEqual:self.titleview]){
        NSString *wholeText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        [self calculateAndDisplayTextFieldLengthWithText:wholeText];
    }
    return result;
}

-(BOOL)textFieldShouldReturn:(UITextField *)titleview{  //输入完毕 放弃第一响应
    [titleview resignFirstResponder];
    return YES;
}
-(void)textFieldDidChanged{    //textField内容发生改变时调用
    [self calculateAndDisplayTextFieldLengthWithText:self.titleview.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{ //点击页面空白部分 键盘消失
//    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
//}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}





@end
