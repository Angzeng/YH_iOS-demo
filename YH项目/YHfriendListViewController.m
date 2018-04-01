//
//  YHfriendListViewController.m
//  YH项目
//
//  Created by Apple on 2017/4/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YHfriendListViewController.h"
#import "YHmemberMainViewController.h"
#import "AFNetworking.h"
#import "YHLoginViewController.h"

@interface YHfriendListViewController ()

@property (strong , nonatomic) NSString *YHToken;
@property (strong , nonatomic) NSString *YHtargetname;

@end

@implementation YHfriendListViewController

- (void)viewDidLoad {
    [self getfriendlist];
    [super viewDidLoad];
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    // Do any additional setup after loading the view.
}

- (void)getfriendlist {
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Friend/friendList";
    NSDictionary *lparameters = @{@"uid":YHuid};
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
                  for (int i=0; i<[dict[@"data"] count]; i++) {
                      NSLog(@"第%d个好友%@",i,dict[@"data"][i]);
                  }
                  //NSLog(@"%@",dict[@"data"][1]);
                  //
                  NSUInteger numberofsection = [dict[@"data"] count];
                  NSLog(@"%lu",(unsigned long)numberofsection);
              }else{
                  NSLog(@"error");
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
          }];
}

- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource

{
    
    for (int i=0; i<dataSource.count; i++) {
        
        RCConversationModel *model =[dataSource objectAtIndex:i];
        
        if (model.conversationType ==ConversationType_SYSTEM) {
            
            model.conversationModelType =RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
            
        }
        
    }
    
    return dataSource;
    
}


- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath{
    YHConversationType = model.conversationType;
    YHConversationTargetId = model.targetId;
    YHConversationTitle = [self getuserimformation:model.targetId];
    NSLog(@"titlehere%@",YHConversationTitle);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"loadconversation" object:self];
}

- (NSString *)getuserimformation:(NSString *)targetuid{
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/User/getUserById";
    NSDictionary *lparameters = @{@"uid":targetuid};
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
                  NSLog(@"%@",dict[@"data"][@"uname"]);
                  _YHtargetname = dict[@"data"][@"uname"];
              }else{
                  NSLog(@"error");
                  _YHtargetname = @"无信息用户";
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
              _YHtargetname = @"无信息用户";
          }];
    return _YHtargetname;
}

//-(RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
//    NSString *string = nil;
//    RCConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
//    if (cell == nil) {
//        cell = [[RCConversationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:string];
//    }
//    return cell;
//}



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
