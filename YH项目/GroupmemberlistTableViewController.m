//
//  YHfriendListTableViewController.m
//  YH项目
//
//  Created by Angzeng on 20/07/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "GroupmemberlistTableViewController.h"
#import "YHConversationCell.h"
#import "AFNetworking.h"
#import "YHLoginViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YHmemberMainViewController.h"
#import "GroupfndViewController.h"
#import "RCInfoPopViewController.h"

@interface GroupmemberlistTableViewController ()

@property (nonatomic , strong) NSMutableArray *CellsItems;
@property (nonatomic , readwrite) NSInteger numberofsection;
@property (nonatomic , strong) NSString *celltargetname;
@property (nonatomic , strong) NSString *celltargetid;
@property (nonatomic , readwrite) NSInteger cellType;
@property (nonatomic , strong) NSString *tempreturn;
@property (nonatomic , strong) NSString *temps;
@property (nonatomic , strong) UIAlertView *alert;
@property (nonatomic , strong) NSString *YHtargetname;

@end

@implementation GroupmemberlistTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getfriendlist];
    NSLog(@"%@",self.tid);

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    NSLog(@"helloaaaa");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _numberofsection;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
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
                  _CellsItems = [[NSMutableArray alloc] init];
                  _CellsItems = [dict objectForKey:@"data"];
                  _numberofsection = [dict[@"data"] count];
                  [self.tableView reloadData];
              }else{
                  NSLog(@"error");
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
          }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RCInfoPopViewController *temp = [[RCInfoPopViewController alloc] init];
    temp.UID = [[_CellsItems objectAtIndex:indexPath.row] objectForKey:@"uid"];
    temp.ifshowdelete = @"YES";
    [self getuserinformation:temp.UID];
    temp.title = _YHtargetname;
    temp.view.backgroundColor = [UIColor whiteColor];
    YHConversationTargetId = temp.UID;
    //
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/TeamUser/isTeamUser";
    NSDictionary *lparameters = @{@"tid":self.tid,@"uid":temp.UID};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置回复内容信息
    [manager.requestSerializer setValue:YHjwt forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:urlStr
       parameters:lparameters//请求参数
          success:^(AFHTTPRequestOperation * operation, id responseObject) {
              NSString *html = operation.responseString;
              NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
              id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
              NSString *tempdata = dict[@"data"];
              NSLog(@"aaa%@",dict[@"data"]);
              NSInteger lojudge = [tempdata intValue];
              if (lojudge==0) {
                  YHtemp = @"ADD";
              }
              else if(lojudge==1) {
                  YHtemp = @"DEL";
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
          }];
    //
    [[NSNotificationCenter defaultCenter]postNotificationName:@"loadinfopro" object:nil];
}

- (void)getuserinformation:(NSString *)targetuid{
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/User/getUserById";
    NSDictionary *lparameters = @{@"uid":targetuid};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置回复内容信息
    [manager.requestSerializer setValue:YHjwt forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:urlStr
       parameters:lparameters//请求参数
          success:^(AFHTTPRequestOperation * operation, id responseObject) {
              NSString *html = operation.responseString;
              NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
              id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
              NSString *judge = dict[@"code"];
              NSInteger lojudge = [judge intValue];
              if (lojudge == 200) {
                  NSLog(@"显示为%@",dict[@"data"][@"uname"]);
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = nil;
    YHConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[YHConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    //setimage
    UIImageView *cellimageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 46, 46)];
    [cellimageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[[_CellsItems objectAtIndex:indexPath.row] objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"imfomation_icon_default"]];
    [cell.contentView addSubview:cellimageview];
    //setname
    UILabel *celltargettitle = [[UILabel alloc] initWithFrame:CGRectMake(66, 10, 200, 23)];
    celltargettitle.text = [[_CellsItems objectAtIndex:indexPath.row] objectForKey:@"uname"];
    _celltargetname = [[NSString alloc] init];
    _celltargetname = celltargettitle.text;
    [cell.contentView addSubview:celltargettitle];
    //setuid
    _celltargetid = [[NSString alloc] init];
    _celltargetid = [[_CellsItems objectAtIndex:indexPath.row] objectForKey:@"uid"];
    _temps = _celltargetid;
    NSLog(@"%@",_temps);
    //
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/TeamUser/isTeamUser";
    NSDictionary *lparameters = @{@"tid":self.tid,@"uid":_celltargetid};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置回复内容信息
    [manager.requestSerializer setValue:YHjwt forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:urlStr
       parameters:lparameters//请求参数
          success:^(AFHTTPRequestOperation * operation, id responseObject) {
              NSString *html = operation.responseString;
              NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
              id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
              NSString *tempdata = dict[@"data"];
              NSLog(@"aaa%@",dict[@"data"]);
              NSInteger lojudge = [tempdata intValue];
              if (lojudge==0) {
                  NSLog(@"nothing");
              }
              else if(lojudge==1) {
                  //setdelete
                  UILabel *delete = [[UILabel alloc] initWithFrame:CGRectMake(66, 33, 64, 23)];
                  delete.textColor = [UIColor grayColor];
                  delete.text = @"已在群组中";
                  delete.font = [UIFont systemFontOfSize:12];
                  [cell addSubview:delete];
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
          }];
    //
    return cell;
}

- (void)backaction {
    UINavigationController *navVC = self.navigationController;
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (UIViewController *vc in [navVC viewControllers]) {
        [viewControllers addObject:vc];
        if ([vc isKindOfClass:[GroupfndViewController class]]) {
            break;
        }
    }
    [navVC setViewControllers:viewControllers animated:YES];
}

- (void)ifinGroup:(NSString *)temptid :(NSString *)tempuid {
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/TeamUser/isTeamUser";
    NSDictionary *lparameters = @{@"tid":temptid,@"uid":tempuid};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置回复内容信息
    [manager.requestSerializer setValue:YHjwt forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:urlStr
       parameters:lparameters//请求参数
          success:^(AFHTTPRequestOperation * operation, id responseObject) {
              NSString *html = operation.responseString;
              NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
              id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
              NSString *tempdata = dict[@"data"];
              if ([tempdata isEqualToString:@"0"]) {
                  _tempreturn = @"0";
              }
              else {
                  _tempreturn = @"1";
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              NSLog(@"发生错误！%@",error);
          }];
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

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    _cellType = 1;
//    YHConversationType = _cellType;
//    YHConversationTargetId = [[_CellsItems objectAtIndex:indexPath.row] objectForKey:@"uid"];
//    YHConversationTitle = [[_CellsItems objectAtIndex:indexPath.row] objectForKey:@"uname"];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"loadconversation" object:self];
//}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
