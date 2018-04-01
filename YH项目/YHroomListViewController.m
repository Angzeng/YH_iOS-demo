//
//  YHroomListViewController.m
//  YH项目
//
//  Created by Apple on 2017/4/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YHroomListViewController.h"
#import "YHmemberMainViewController.h"
#import "YHLoginViewController.h"
#import "AFNetworking.h"

@interface YHroomListViewController ()

@property (strong , nonatomic) NSString *YHtargetname;

@end

@implementation YHroomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDisplayConversationTypes:@[@(ConversationType_GROUP)]];
    // Do any additional setup after loading the view.
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath{
    YHConversationType = model.conversationType;
    YHConversationTargetId = model.targetId;
    NSLog(@"tidhere%@",model.targetId);
    YHConversationTitle = [self getuserimformation:model.targetId];
    NSLog(@"title%@",YHConversationTitle);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"loadconversation" object:self];
}

- (NSString *)getuserimformation:(NSString *)targetuid{
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/Team/getTeamInfo";
    NSDictionary *lparameters = @{@"tid":targetuid};
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
                  NSLog(@"tiddata%@",dict[@"data"]);
                  _YHtargetname = dict[@"data"][0][@"tname"];
                  NSLog(@"%@",_YHtargetname);
              }else{
                  NSLog(@"error");
                  _YHtargetname = @"无信息群组";
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
              _YHtargetname = @"无信息群组";
          }];
    return _YHtargetname;
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
