//
//  YHQuestionViewController.m
//  YH项目
//
//  Created by 渡。 on 2017/5/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YHQuestionViewController.h"
#import "YHLoginViewController.h"
#import "YHTabBarController.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface YHQuestionViewController ()

@property (nonatomic,readonly) NSInteger screenWidth;
@property (nonatomic,readwrite) NSInteger Qid;
@property (nonatomic,readwrite) NSInteger Qcount;
@property (strong, nonatomic)  NSString *charid;
@property (nonatomic,strong) UILabel *informationLabel;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) UILabel *questionLabel;
@property (nonatomic,strong) UILabel *leftSelection;
@property (nonatomic,strong) UILabel *leftAnswerlabel;
@property (nonatomic,strong) UILabel *rightSelection;
@property (nonatomic,strong) UILabel *rightAnswerlabel;
@property (nonatomic,strong) UIAlertView *quizalert;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,readwrite) NSInteger tempqid;
@property (nonatomic , readwrite) NSInteger n;
@property (nonatomic , strong) id dict;
//
@property (nonatomic , strong) NSData *datas;

@end

@implementation YHQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _n = 0;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    [self.navigationItem setHidesBackButton:YES];
    self.view.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, w, h-64)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    self.navigationItem.title = @"模型获取";
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    _tempqid = 0;
    [self initqid];
}

- (void)initqid {
    self.Qid = _tempqid+1;
    NSLog(@"qid初始值%ld",(long)self.Qid);
    self.Qcount = 1;
    [self CreateUI];
}

- (void)CreateUI{
    _informationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _bgView.frame.origin.y, _screenWidth, 44)];
    _informationLabel.text = @"通过回答问题组建您的财富模型";
    _informationLabel.numberOfLines = 0;
    _informationLabel.backgroundColor = [UIColor clearColor];
    _informationLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:12.0f];
    _informationLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_informationLabel];
    
    _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _informationLabel.frame.origin.y+_informationLabel.frame.size.height, _screenWidth, 44)];
    _countLabel.numberOfLines = 0;
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16.0f];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_countLabel];
    
    _questionLabel = [[UILabel alloc] init];
    [_questionLabel setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:20.0f]];
    [_questionLabel setTextAlignment:NSTextAlignmentCenter];
    [_questionLabel setLineBreakMode:NSLineBreakByWordWrapping];
    _questionLabel.textColor = [UIColor blackColor];
    _questionLabel.numberOfLines = 0;
    _questionLabel.layer.cornerRadius = 8;
    _questionLabel.layer.masksToBounds = YES;
    _questionLabel.layer.borderWidth = 1;
    _questionLabel.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.view addSubview:_questionLabel];
    
    _leftSelection = [[UILabel alloc] init];
    _leftSelection.text = @"A:";
    _leftSelection.textColor = [UIColor blackColor];
    [_leftSelection setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:20.0f]];
    [_leftSelection setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_leftSelection];
    
    _rightSelection = [[UILabel alloc] init];
    _rightSelection.text = @"B:";
    _rightSelection.textColor = [UIColor blackColor];
    [_rightSelection setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:20.0f]];
    [_rightSelection setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_rightSelection];
    
    UIGestureRecognizer *gesture;
    
    _leftAnswerlabel = [[UILabel alloc] init];
    [_leftAnswerlabel setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:20.0f]];
    [_leftAnswerlabel setTextAlignment:NSTextAlignmentCenter];
    [_leftAnswerlabel setLineBreakMode:NSLineBreakByWordWrapping];
    _leftAnswerlabel.textColor = [UIColor blackColor];
    _leftAnswerlabel.numberOfLines = 0;
    _leftAnswerlabel.layer.cornerRadius = 8;
    _leftAnswerlabel.layer.masksToBounds = YES;
    _leftAnswerlabel.layer.borderWidth = 1;
    _leftAnswerlabel.layer.borderColor = [[UIColor blackColor] CGColor];
    _leftAnswerlabel.userInteractionEnabled=YES;
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(submitAnswer:)];
    gesture.view.tag = 10000;
    [_leftAnswerlabel addGestureRecognizer:gesture];
    [self.view addSubview:_leftAnswerlabel];
    
    _rightAnswerlabel = [[UILabel alloc] init];
    [_rightAnswerlabel setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:20.0f]];
    [_rightAnswerlabel setTextAlignment:NSTextAlignmentCenter];
    [_rightAnswerlabel setLineBreakMode:NSLineBreakByWordWrapping];
    _rightAnswerlabel.textColor = [UIColor blackColor];
    _rightAnswerlabel.numberOfLines = 0;
    _rightAnswerlabel.layer.cornerRadius = 8;
    _rightAnswerlabel.layer.masksToBounds = YES;
    _rightAnswerlabel.layer.borderWidth = 1;
    _rightAnswerlabel.layer.borderColor = [[UIColor blackColor] CGColor];
    _rightAnswerlabel.userInteractionEnabled=YES;
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(submitAnswer:)];
    gesture.view.tag = 10002;
    [_rightAnswerlabel addGestureRecognizer:gesture];
    [self.view addSubview:_rightAnswerlabel];
    if ([self.islastone isEqualToString:@"52"]) {
        [self getqueslast];
        NSLog(@"here");
    }else {
        [self getques];
    }
}

-(void)postUserFeature:(NSNumber*) change{
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Feature/feature";
    NSDictionary *parameters;
    if ([(change) intValue] == 0) {
        parameters = @{@"type":@2,@"uid":YHuid,@"charid":_charid,@"change":@0};
    }
    else {
        parameters = @{@"type":@2,@"uid":YHuid,@"charid":_charid,@"change":@2};
    }
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
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              
          }];
}

- (void)getques {
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Question/getQuestionsOfUser";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //设置回复内容信息
        [manager.requestSerializer setValue:YHjwt forHTTPHeaderField:@"Authorization"];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [manager GET:urlStr
          parameters:nil//请求参数
         success:^(AFHTTPRequestOperation * operation, id responseObject){
             NSString *html = operation.responseString;
             NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
             _dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
             NSString *code = [NSString stringWithFormat:@"%@",_dict[@"code"]];
             if ([code isEqualToString:@"200"]) {
                 NSLog(@"%@aa",_dict[@"data"]);
                 [self loadQuestion:_dict[@"data"][0]];
             }else{
                 [self presentAlert:1];
                 [self loadTabBarController];
             }
         }
         failure:^(AFHTTPRequestOperation * operation, NSError * error) {
             [self presentAlert:1];
         }];
}

- (void)getqueslast {
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Question/getQuestionsOfUser";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"pagesize":@1};
    //设置回复内容信息
    [manager.requestSerializer setValue:YHjwt forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager GET:urlStr
      parameters:parameters//请求参数
         success:^(AFHTTPRequestOperation * operation, id responseObject){
             NSString *html = operation.responseString;
             NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
             _dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
             NSString *code = [NSString stringWithFormat:@"%@",_dict[@"code"]];
             if ([code isEqualToString:@"200"]) {
                 NSLog(@"%@aa",_dict[@"data"]);
                 [self loadQuestion:_dict[@"data"][_n]];
             }else{
                 [self presentAlert:1];
                 [self loadTabBarController];
             }
         }
         failure:^(AFHTTPRequestOperation * operation, NSError * error) {
             [self presentAlert:1];
         }];
}

- (void) submitAnswer:(UIGestureRecognizer *) sender{
    //计数器自加
    _Qcount = _Qcount +1;
    //上传数据
    _Qid= _Qid+1;
    if ([self.islastone isEqualToString:@"52"]) {
        [self presentAlert:0];
        [self postUserFeature:[[NSNumber alloc] initWithInteger:sender.view.tag - 10000]];
        [self loadTabBarController];
    }else {
        if (_Qcount<5) {
            [self postUserFeature:[[NSNumber alloc] initWithInteger:sender.view.tag - 10000]];
            _n = _n+1;
            [self loadQuestion:_dict[@"data"][_n]];
        }else{
            [self presentAlert:0];
            [self postUserFeature:[[NSNumber alloc] initWithInteger:sender.view.tag - 10000]];
            [self loadTabBarController];
        }
    }
}

- (void)loadQuestion:(NSDictionary *)items{
    _charid = items[@"charid"];
    _questionLabel.text = items[@"q_content"];
    _countLabel.text = [NSString stringWithFormat:@"%ld/4",(long)_Qcount];
    CGFloat sep = 20;
    CGFloat w = _screenWidth - 2*sep;
    CGSize size = [_questionLabel sizeThatFits:CGSizeMake(w, MAXFLOAT)];
    [_questionLabel setFrame:CGRectMake(sep, _countLabel.frame.origin.y+_countLabel.frame.size.height+sep, w, size.height)];
    
    w = _screenWidth - 4*sep;
    _leftAnswerlabel.text = items[@"op1"];
    size = [_leftAnswerlabel sizeThatFits:CGSizeMake(w, MAXFLOAT)];
    [_leftSelection setFrame:CGRectMake(0, _questionLabel.frame.origin.y+_questionLabel.frame.size.height+2*sep, sep*2, size.height)];
    [_leftAnswerlabel setFrame:CGRectMake(sep*2, _leftSelection.frame.origin.y, w, size.height)];
    
    _rightAnswerlabel.text = items[@"op2"];
    size = [_rightAnswerlabel sizeThatFits:CGSizeMake(w, MAXFLOAT)];
    [_rightSelection setFrame:CGRectMake(0, _leftSelection.frame.origin.y+_leftSelection.frame.size.height+2*sep, sep*2, size.height)];
    [_rightAnswerlabel setFrame:CGRectMake(sep*2, _rightSelection.frame.origin.y, w, size.height)];
}

-(void) presentAlert:(NSInteger)type{
    NSString *alert = @"";
    switch (type) {
        case 0:
            alert = @"财富特征测试完成";
            break;
        case 1:
            alert = @"网络错误";
            break;
        default:
            break;
    }
    //设置alert时间响应
    _quizalert=[[UIAlertView alloc]initWithTitle:alert message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
    [_quizalert show];
}

-(void) performDismiss:(NSTimer *)timer
{
    [_quizalert dismissWithClickedButtonIndex:0 animated:NO];
}

-(void) loadTabBarController{
    YHTabBarController *next = [[YHTabBarController alloc] init];
    [self presentViewController:next animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
