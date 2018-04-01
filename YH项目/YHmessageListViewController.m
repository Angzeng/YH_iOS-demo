//
//  YHmessageListViewController.m
//  YH项目
//
//  Created by Apple on 2017/4/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YHmessageListViewController.h"
#import "YHmemberMainViewController.h"
#import "YHLoginViewController.h"
#import "AFNetworking.h"
#import "YHMessageContent.h"
#import "YHMessage.h"
#import "CheckmessageTableViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>

@interface YHmessageListViewController ()

@property (strong , nonatomic) NSString *YHToken;
@property (nonatomic , weak) id<RCIMReceiveMessageDelegate> reciveMessageDelegate;
@property (nonatomic , strong) NSString *targettitle;

@end

@implementation YHmessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.conversationListTableView.backgroundColor = [UIColor whiteColor];
    CGRect frame = self.conversationListTableView.frame;
    frame.size.height = self.view.frame.size.height-110*[UIScreen mainScreen].bounds.size.height/568;
    self.conversationListTableView.frame = frame;
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_GROUP)]];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self.conversationListTableView reloadData];
        [self endRefresh];
    }];
    self.conversationListTableView.mj_header = header;
}

-(void) endRefresh{
    if ([self.conversationListTableView.mj_header isRefreshing]) {
        [self.conversationListTableView.mj_header endRefreshing];
    }
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath{
    YHConversationType = model.conversationType;
    YHConversationTargetId = model.targetId;
    YHConversationSenderId = model.senderUserId;
    if ([model.senderUserId isEqual: @"10000"]||[model.targetId isEqualToString:@"10000"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loadcheckmessage" object:nil];
    }else {
        if (model.conversationType == 1) {
            [self getuserimformation:model.targetId];
            YHConversationTitle = _targettitle;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loadconversation" object:nil];
        }
        else if (model.conversationType == 3) {
            [self getgroupimformation:model.targetId];
            YHConversationTitle = _targettitle;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loadgroup" object:nil];
        }
    }
}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
        [self onRCIMReceiveMessage:notification.object left:notification.userInfo[@"left"]];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    RCConversationModel *model = [self.conversationListDataSource objectAtIndex:indexPath.row];
    if([model.senderUserId isEqualToString:@"10000"]||[model.targetId isEqualToString:@"10000"]){
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)onRCIMReceiveMessage:(YHMessage *)message
                        left:(int)left {
    if ([message.objectName isEqualToString:@"RC:ContactNtf"]) {
        RCMessageContent *content = [[RCMessageContent alloc] init];
        content = message.content;
        RCContactNotificationMessage *addmessage = (RCContactNotificationMessage*)content;
        YHnewId = addmessage.sourceUserId;
        [self initarray:YHnewId];
    }
}

-(void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell
                            atIndexPath:(NSIndexPath *)indexPath
{
    RCConversationModel *model=cell.model;
    if (model.conversationType == ConversationType_PRIVATE) {
        if ([model.senderUserId isEqualToString:@"10000"]) {
            RCConversationCell *concell = (RCConversationCell *)cell;
            concell.conversationTitle.textColor = [UIColor blueColor];
            concell.model.isTop = YES;
        }
    }
}

- (void)initarray:(NSString *)sourceUserId {
    NSArray *temparry = [[NSArray alloc] init];
    temparry = [defaultlist objectForKey:@"mujun"];
    if (temparry[0] != nil) { 
        CellsourceUserId = [[NSMutableArray alloc] initWithArray:temparry];
        for(int i=0;i<temparry.count;i++){
            if(![temparry[i] isEqualToString:sourceUserId]){
                [CellsourceUserId addObject:sourceUserId];
                defaultlist = [NSUserDefaults standardUserDefaults];
                [defaultlist setObject:CellsourceUserId  forKey:@"mujun"];
                [defaultlist synchronize];
            }
        }
    }else {
        NSArray *defaultinit = [[NSArray alloc] initWithObjects:sourceUserId, nil];
        defaultlist = [NSUserDefaults standardUserDefaults];
        [defaultlist setObject:defaultinit  forKey:@"mujun"];
        [defaultlist synchronize];
    }
}

- (void)getuserimformation:(NSString *)targetuid{
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
                  _targettitle = dict[@"data"][@"uname"];
              }else{
                  NSLog(@"error");
                  _targettitle = @"无信息用户";
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
              _targettitle = @"无信息用户";
          }];
}

- (void)getgroupimformation:(NSString *)targetuid{
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
                  _targettitle = dict[@"data"][0][@"tname"];
              }else{
                  NSLog(@"error");
                  _targettitle = @"无信息群组";
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
              _targettitle = @"无信息群组";
          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

