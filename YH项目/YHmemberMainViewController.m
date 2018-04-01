//
//  YHmemberMainViewController.m
//  YH项目
//
//  Created by Apple on 2017/4/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YHmemberMainViewController.h"
#import "YHmessageListViewController.h"
#import "YHfriendListViewController.h"
#import "YHroomListViewController.h"
#import "AddFriendViewController.h"
#import "AddGroupViewController.h"
#import "CreatGroupViewController.h"
#import "CheckMessageViewController.h"
#import "AFNetworking.h"
#import "YHLoginViewController.h"
#import "YHConversationViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "YHfriendListTableViewController.h"
#import "YHgroupListTableViewController.h"
#import "YHGroupConversationViewController.h"
#import "CheckmessageTableViewController.h"

@interface YHmemberMainViewController ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource>


@property (strong , nonatomic) YHmessageListViewController *messagelist;
@property (strong , nonatomic) YHfriendListViewController *friendlist;
@property (strong , nonatomic) YHroomListViewController *roomlist;
@property (strong , nonatomic) AddFriendViewController *addfriend;
@property (strong , nonatomic) AddGroupViewController *addgroup;
@property (strong , nonatomic) CreatGroupViewController *creatgroup;
@property (strong , nonatomic) CheckMessageViewController *checkmessage;
@property (strong , nonatomic) UIViewController *moment;
@property (strong , nonatomic) UIButton *AddButton;
@property (strong , nonatomic) UIView *Add;
@property (strong , nonatomic) UIButton *disapper;
@property (nonatomic , readwrite) NSInteger checklist;
@property (nonatomic , strong) UIAlertView *alert;
@property (nonatomic , strong) NSString *RongyunToken;
@property (nonatomic , strong) UIWindow *window;
//
@property (strong , nonatomic) RCConversationListViewController *messagelistview;
@property (strong , nonatomic) RCConversationListViewController *friendlistview;
@property (strong , nonatomic) RCConversationListViewController *roomlistview;
@property (strong , nonatomic) NSString *YHtargetname;
@property (strong , nonatomic) UIView *scrollview;
//
@property (strong , nonatomic) YHfriendListTableViewController *friendlisttableview;
@property (strong , nonatomic) YHgroupListTableViewController *grouplisttableview;
//
@end

NSString *YHConversationTargetId;
NSString *YHConversationSenderId;
NSString *YHConversationTitle;
RCConversationType *YHConversationType;
NSString *YHnewId;
NSString *YHshowdelete;

@implementation YHmemberMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setnavigationbar];
    [self RongyunLoginprepare];
    [self RongyunLogin];
    _checklist = 0;
    
    [self initview];
    [self performSelector:@selector(initview) withObject:nil afterDelay:0.5f];
    [self setupAdd];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkmessageaction) name:@"loadcheckmessage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(conversationaction) name:@"loadconversation" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(groupaction) name:@"loadgroup" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(initview) name:@"list" object:nil];
}

- (void)initview {
    [self remove];
    NSLog(@"zhixingl");
    //
    _messagelist = [[YHmessageListViewController alloc] init];
    [self.view addSubview:_messagelist.view];
    self.messagelistview = _messagelist;
}

- (void)groupaction {
    YHGroupConversationViewController *YGC = [[YHGroupConversationViewController alloc] init];
    YGC.conversationType = YHConversationType;
    YGC.targetId = YHConversationTargetId;
    YGC.title = YHConversationTitle;
    [self.navigationController pushViewController:YGC animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)conversationaction {
    YHConversationViewController *YC = [[YHConversationViewController alloc] init];
    YC.got = @"got";
    YC.conversationType = YHConversationType;
    YC.targetId = YHConversationTargetId;
    YC.title = YHConversationTitle;
    [self.navigationController pushViewController:YC animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)firstviewinit {
    _messagelist = [[YHmessageListViewController alloc] init];
    [self.view addSubview:_messagelist.view];
    self.messagelistview = _messagelist;
}

- (void)RongyunLoginprepare {
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/IMUser/getToken";
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
                  _RongyunToken = dict[@"data"];
                  [self RongyunLogin];
              }else{
                  NSLog(@"error");
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
          }];
}

- (void)RongyunLogin {
    [[RCIM sharedRCIM] initWithAppKey:@"c9kqb3rdcx94j"];
    [[RCIM sharedRCIM] connectWithToken:_RongyunToken success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        [[RCIM sharedRCIM] setGroupInfoDataSource:self];
        [RCIM sharedRCIM].enableMessageRecall = YES;
        [RCIM sharedRCIM].enableTypingStatus = YES;
        [self sendmessage];
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        NSLog(@"token错误");
    }];
}

- (void)sendmessage {
    RCContactNotificationMessage *textMessage = [[RCContactNotificationMessage alloc] init];
    textMessage.extra = @"0";
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:@"10000" content:textMessage pushContent:@"login" success:^(long messageId) {
        NSLog(@"success == %ld",messageId);
    } error:^(RCErrorCode nErrorCode, long messageId) {
        NSLog(@"nErrorCode== %ld",messageId);
    }];
}

- (void)setnavigationbar {
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    //
    NSArray *array = @[@"消息",@"财友",@"董事会"];
    UISegmentedControl *segmentedcontroller = [[UISegmentedControl alloc] initWithItems:array];
    [segmentedcontroller addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedcontroller];
    self.navigationItem.titleView = segmentedcontroller;
    [self.navigationItem.titleView setFrame:CGRectMake(self.view.frame.size.width-120-(self.view.frame.size.width-120)/2, 10, 120, 30)];
    segmentedcontroller.translatesAutoresizingMaskIntoConstraints = NO;
    
    segmentedcontroller.selectedSegmentIndex = 0;

}

- (void)segmentAction:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:{
            NSLog(@"0");
            //
            [self remove];
            //
            _messagelist = [[YHmessageListViewController alloc] init];
            [self.view addSubview:_messagelist.view];
            self.messagelistview = _messagelist;
        }
            break;
        case 1:{
            NSLog(@"1");
            //
            [self remove];
            //
            _friendlisttableview = [[YHfriendListTableViewController alloc] init];
            _friendlisttableview.view.frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height-44);
            [self.view addSubview:_friendlisttableview.view];
            self.friendlisttableview = _friendlisttableview;

        }
            break;
        case 2:{
            NSLog(@"2");
            //
            [self remove];
            //
            _grouplisttableview = [[YHgroupListTableViewController alloc] init];
            _grouplisttableview.view.frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height-44);
            [self.view addSubview:_grouplisttableview.view];
            self.grouplisttableview = _grouplisttableview;
        }
            break;
        default:
            break;
    }
}

- (void)remove {
    [_messagelist.view removeFromSuperview];
    [_friendlist.view removeFromSuperview];
    [_roomlist.view removeFromSuperview];
}

- (void)setupAdd {  //添加按钮
    UIButton * AddButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [AddButton setImage:[UIImage imageNamed:@"chat_bottom_up_nor.png"] forState:UIControlStateNormal];
    //[AddButton setBackgroundColor:[UIColor whiteColor]];
    [AddButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchDown];
    //这里添加上传事件响应
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithCustomView:AddButton];
    self.navigationItem.rightBarButtonItem=rightItem;
}

- (void)add {
    

    if (_checklist == 0) {
        
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor colorWithRed:88/255.0 green:87/255.0 blue:86/255.0 alpha:0.3];
        _window.windowLevel = UIWindowLevelAlert - 1;
        _window.hidden = NO;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissWindow)];
        [_window addGestureRecognizer:tap];
         //
        // 状态栏(statusbar)
        CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
        NSLog(@"status width - %f", rectStatus.size.width); // 宽度
        NSLog(@"status height - %f", rectStatus.size.height);  // 高度
        
        
        // 导航栏（navigationbar）
        CGRect rectNav = self.navigationController.navigationBar.frame;
        NSLog(@"nav width - %f", rectNav.size.width); // 宽度
        NSLog(@"nav height - %f", rectNav.size.height);  // 高度
        
        NSLog(@"%f%f",[UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width);
        
        NSLog(@"%f%f",self.view.frame.size.width,self.view.frame.size.height);
        //
        int sheight = 40*[UIScreen mainScreen].bounds.size.height/568;
        int swidth = 120*[UIScreen mainScreen].bounds.size.width/320;
        _Add = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-(swidth+2), 64, (swidth+2)*568/[UIScreen mainScreen].bounds.size.height, sheight*4+5)];
        _Add.backgroundColor = [UIColor whiteColor];
        //
        UIButton *addfriend = [[UIButton alloc]initWithFrame:CGRectMake(1, 1, swidth, sheight)];
        [addfriend addTarget:self action:@selector(addfriendaction) forControlEvents:UIControlEventTouchDown];
        addfriend.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
        [addfriend setTitle:@"添加好友" forState:UIControlStateNormal];
        [addfriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addfriend setFont:[UIFont boldSystemFontOfSize:14]];
        //
        UIButton *addgroup = [[UIButton alloc]initWithFrame:CGRectMake(1, sheight+2, swidth, sheight)];
        [addgroup addTarget:self action:@selector(addgroupaction) forControlEvents:UIControlEventTouchDown];
        addgroup.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
        [addgroup setTitle:@"添加群组" forState:UIControlStateNormal];
        [addgroup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addgroup setFont:[UIFont boldSystemFontOfSize:14]];
        //
        UIButton *creatgroup = [[UIButton alloc]initWithFrame:CGRectMake(1, 2*sheight+3, swidth, sheight)];
        [creatgroup addTarget:self action:@selector(creatgroupaction) forControlEvents:UIControlEventTouchDown];
        creatgroup.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
        [creatgroup setTitle:@"创建群组" forState:UIControlStateNormal];
        [creatgroup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [creatgroup setFont:[UIFont boldSystemFontOfSize:14]];
        //
        UIButton *checkmessage = [[UIButton alloc]initWithFrame:CGRectMake(1, 3*sheight+4, swidth, sheight)];
        [checkmessage addTarget:self action:@selector(checkmessageaction) forControlEvents:UIControlEventTouchDown];
        checkmessage.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
        [checkmessage setTitle:@"验证消息" forState:UIControlStateNormal];
        [checkmessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [checkmessage setFont:[UIFont boldSystemFontOfSize:14]];
        //
        [_window addSubview:_Add];
        [_Add addSubview:addfriend];
        [_Add addSubview:addgroup];
        [_Add addSubview:creatgroup];
        [_Add addSubview:checkmessage];
        //
        _checklist = 1;
    }
}

- (void)addfriendaction {
    [_Add removeFromSuperview];
    [_disapper removeFromSuperview];
    _checklist = 0;
    self.addfriend = [[AddFriendViewController alloc] init];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:_addfriend animated:YES];
}

- (void)addgroupaction {
    [_Add removeFromSuperview];
    [_disapper removeFromSuperview];
    _checklist = 0;
    self.addgroup = [[AddGroupViewController alloc] init];
    [self.navigationController pushViewController:_addgroup animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)creatgroupaction {
    [_Add removeFromSuperview];
    [_disapper removeFromSuperview];
    _checklist = 0;
    self.creatgroup = [[CreatGroupViewController alloc] init];
    [self.navigationController pushViewController:_creatgroup animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)checkmessageaction {
    [_Add removeFromSuperview];
    [_disapper removeFromSuperview];
    _checklist = 0;
    self.checkmessage = [[CheckMessageViewController alloc] init];
    [self.navigationController pushViewController:_checkmessage animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *userInfo))completion{
    if ([userId isEqualToString:@"10000"]) {
        RCUserInfo *userInfo = [[RCUserInfo alloc] init];
        userInfo.userId = userId;
        userInfo.name = @"新消息";
        userInfo.portraitUri = [NSString stringWithFormat:@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3141894857,4122422296&fm=117&gp=0.jpg"];
        return completion(userInfo);
    }
    else{
        NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/User/getUserById";
        NSDictionary *lparameters = @{@"uid":userId};
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
                      NSLog(@"%@",dict[@"data"]);
                      RCUserInfo *userInfo = [[RCUserInfo alloc] init];
                      userInfo.userId = userId;
                      userInfo.name = dict[@"data"][@"uname"];
                      userInfo.portraitUri = [NSString stringWithFormat:@"http://%@",dict[@"data"][@"avatar"]];
                      return completion(userInfo);
                  }else{
                      NSLog(@"error");
                      return completion(nil);
                  }
              }
              failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                  NSLog(@"发生错误！%@",error);
              }];
    }
    return completion(nil);
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion{
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Team/getTeamInfo";
    NSDictionary *lparameters = @{@"tid":groupId};
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
                  NSLog(@"%@",dict[@"data"]);
                  RCGroup *groupInfo = [[RCGroup alloc] init];
                  groupInfo.groupId = groupId;
                  groupInfo.groupName = dict[@"data"][0][@"tname"];
                  groupInfo.portraitUri = [NSString stringWithFormat:@"http://%@",dict[@"data"][0][@"tavatar"]];
                  return completion(groupInfo);
              }else{
                  NSLog(@"error");
                  return completion(nil);
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
          }];
    return completion(nil);
}

#pragma mark - 数据刷新请求- begin



#pragma mark - 数据刷新请求 - end

-(void)dismissWindow{
    [_Add removeFromSuperview];
    [_disapper removeFromSuperview];
    _checklist = 0;
    _window.hidden = YES;
    _window = nil;
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
}

//
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
