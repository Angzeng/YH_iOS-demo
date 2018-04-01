//
//  GRZXeditInfoController.m
//  个人中心
//
//  Created by Apple on 15/11/8.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "GRZXeditInfoController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GRZXmainController.h"
#import "YHLoginViewController.h"
#import "AFNetworking.h"

@interface GRZXeditInfoController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *ageText;
//@property (weak, nonatomic) IBOutlet UITextField *sexText;
@property (strong, nonatomic) UISegmentedControl *sexselect;
@property (weak, nonatomic) IBOutlet UITextField *workText;
@property (weak, nonatomic) IBOutlet UITextField *addrText;
//@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UIScrollView *bac;
@property (weak, nonatomic) IBOutlet UIView *iconback;
@property (nonatomic, strong) UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *sexview;
@property (weak, nonatomic) IBOutlet UIButton *changeicon;
@property (nonatomic, strong) NSString *iconavater;


- (IBAction)saveBtnClick:(id)sender;
- (void)savedata;


@end

@implementation GRZXeditInfoController

//此时并没有创建view因此没有自控件
/*
-(void)setUser:(GRZXuser *)user{

    _user = user;
    
    self.iconView.image = [UIImage imageNamed:user.icon];
    self.nameText.text = user.name;
    self.ageText.text = [NSString stringWithFormat:@"%ld",(long)user.age];
    self.sexText.text = [NSString stringWithFormat:@"%ld",(long)user.sex];
    self.workText.text = user.work;
    self.addrText.text = user.address;
    self.phoneText.text = user.phoneNumber;
    
}
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    _screenWidth = [UIScreen mainScreen].bounds.size.width;//获取屏幕大小
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    //

    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    // Do any additional setup after loading the view.
    self.iconView.image = [UIImage imageNamed:self.user.icon];
    self.nameText.text = self.user.name;
    self.ageText.text = [NSString stringWithFormat:@"%ld",(long)self.user.age];
    //self.sexText.text = [NSString stringWithFormat:@"%ld",(long)self.user.sex];
    
    self.workText.text = self.user.work;
    self.addrText.text = self.user.address;
    //self.phoneText.text = self.user.phoneNumber;
    //
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/User/user";
    NSDictionary *parameters = @{@"uid":YHuid};
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

              _iconavater = dict[@"data"][0][@"avatar"];
              _icon = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 80, 80)];
              [self.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",_iconavater]] placeholderImage:[UIImage imageNamed:@"imfomation_icon_default"]];
              
              [self.iconback addSubview:_icon];


              
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              
          }];
    //
    
    //
    NSArray *array = @[@"男",@"女"];
    
    UISegmentedControl *segmentedController = [[UISegmentedControl alloc] initWithItems:array];
    segmentedController.tintColor=[UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    [segmentedController setFrame:CGRectMake(_screenWidth-100,10,80, 24)];
    segmentedController.selectedSegmentIndex = self.user.sex;
    
    [segmentedController addTarget:self action:@selector(setupsextype:) forControlEvents:UIControlEventValueChanged];
    
    [self.sexview addSubview:segmentedController];
    
}

- (IBAction)changgeicon:(id)sender {
     performSelector:withObject:afterDelay:1;
}



-(void)setupsextype:(id)sender{
    switch ([sender selectedSegmentIndex]) {
        case 0:{
            self.user.sex=0;
        }
            break;
        case 1:{
            self.user.sex=1;
        }
            break;
        }
}

-(void)viewDidAppear:(BOOL)animated{
    //[self.nameText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)savedata{

    self.user.name = self.nameText.text;
    self.user.age = [self.ageText.text integerValue];
    //self.user.sex = [self.sexText.text integerValue];
    
    self.user.work = self.workText.text;
    self.user.address = self.addrText.text;
    //self.user.phoneNumber = self.phoneText.text;
    //
    [self changname];
    [self changage];
    [self changegender];
    [self changeindustry];
    [self changeposition];
    
    

}

-(void)changname{
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/User/user";
    NSDictionary *parameters = @{@"uid":YHuid,@"type":@"2",@"modkey":@"uname",@"modvalue":self.user.name};
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
              //NSLog(@"%@",dict);
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              
          }];
    
}

-(void)changage{
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/User/user";
    NSString *age = [NSString stringWithFormat:@"%ld",(long)self.user.age];
    NSDictionary *parameters = @{@"uid":YHuid,@"type":@"2",@"modkey":@"birthday",@"modvalue":age};
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
              //NSLog(@"%@",dict);
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              
          }];
    
}

-(void)changegender{
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/User/user";
    NSString * gender = [NSString stringWithFormat:@"%ld",(long)self.user.sex];
    NSDictionary *parameters = @{@"uid":YHuid,@"type":@"2",@"modkey":@"gender",@"modvalue":gender};
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
              //NSLog(@"%@",dict);
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              
          }];
    
}

-(void)changeindustry{
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/User/user";
    NSDictionary *parameters = @{@"uid":YHuid,@"type":@"2",@"modkey":@"industry",@"modvalue":self.user.address};
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
              //NSLog(@"%@",dict);
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              
          }];
    
}

-(void)changeposition{
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/User/user";
    NSDictionary *parameters = @{@"uid":YHuid,@"type":@"2",@"modkey":@"position",@"modvalue":self.user.work};
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
              //NSLog(@"%@",dict);
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              
          }];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //回收键盘
    [self.view endEditing:YES];
    
}




- (IBAction)saveBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    //self.tabBarController.tabBar.hidden = NO;
    

    
    [self savedata];
    
    if ([self.delegate respondsToSelector:@selector(saveInfoWithControl:andUser:)]) {
        [self.delegate saveInfoWithControl:self andUser:self.user];
    }
}
@end
