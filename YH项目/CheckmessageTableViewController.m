//
//  CheckmessageTableViewController.m
//  YH项目
//
//  Created by norton on 2017/6/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CheckmessageTableViewController.h"
#import "YHConversationCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YHLoginViewController.h"
#import "YHmemberMainViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>

@interface CheckmessageTableViewController ()

@property (nonatomic , strong) NSArray *CellssourceUserId;
@property (nonatomic , strong) NSArray *CellsinitsourceUserId;
@property (nonatomic , readwrite) NSInteger numberofsection;
@property (nonatomic , strong) NSString *celltargetname;
@property (nonatomic , strong) NSString *celltargetid;
@property (nonatomic , readwrite) NSInteger cellType;
@property (nonatomic , strong) NSString *isfriend;
@property (nonatomic , strong) NSString *user;
@property (nonatomic , strong) NSString *target;
@property (nonatomic , strong) UIAlertView *alert;

@end

NSUserDefaults *defaultlist;
NSMutableArray *CellsourceUserId;

@implementation CheckmessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    _CellsinitsourceUserId = [defaultlist objectForKey:@"mujun"];
    _CellssourceUserId = [[NSArray alloc] initWithArray:_CellsinitsourceUserId];
    [self showcell];
    [self.tableView reloadData];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self showcell];
//        [self.tableView reloadData];
        [self deletemessage];
        [self endRefresh];
    }];
    self.tableView.mj_header = header;
}

-(void)deletemessage {
    _CellssourceUserId = nil;
    defaultlist = [NSUserDefaults standardUserDefaults];
    [defaultlist setObject:_CellssourceUserId  forKey:@"mujun"];
    [defaultlist synchronize];
    [self showcell];
    [self.tableView reloadData];
}

-(void) endRefresh{
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
}

- (void)showcell {
    for (int i = 0; i < _CellssourceUserId.count; i++)
    {
        NSString *str1 = [_CellssourceUserId objectAtIndex:i];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _CellssourceUserId.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = nil;
    YHConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[YHConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //setimage
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/User/user";
    NSDictionary *parameters = @{@"uid":[_CellssourceUserId objectAtIndex:indexPath.row]};
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
              
              NSString *iconavater = dict[@"data"][0][@"avatar"];
              //
              UIImageView *cellimageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 46, 46)];
              [cellimageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",iconavater]] placeholderImage:[UIImage imageNamed:@"imfomation_icon_default"]];
              [cell.contentView addSubview:cellimageview];
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
          }];
    //setname
    UILabel *set = [[UILabel alloc] initWithFrame:CGRectMake(76, 23, self.view.frame.size.width-74-56-10, 32)];
    [set setFont:[UIFont boldSystemFontOfSize:12.0]];
    set.text = @"交个朋友嘛!";
    set.textColor = [UIColor darkGrayColor];
    [cell addSubview:set];
    //
    UILabel *celllable = [[UILabel alloc] initWithFrame:CGRectMake(76, 11, 64 ,32)];
    [celllable setFont:[UIFont boldSystemFontOfSize:12.0]];
    celllable.text = [_CellssourceUserId objectAtIndex:indexPath.row];
    celllable.textColor = [UIColor lightGrayColor];
    [cell addSubview:celllable];
    //setbutton
    UIButton *add = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-74, 17, 64 ,32)];
    add.backgroundColor = [UIColor lightGrayColor];
    add.titleLabel.font = [UIFont boldSystemFontOfSize: 12.0];
    [cell addSubview:add];
    
    if ([_isfriend isEqualToString:@"1"]) {
        add.backgroundColor = [UIColor lightGrayColor];
        [add setTitle:@"已经添加" forState:UIControlStateNormal];
        add.titleLabel.textColor = [UIColor darkGrayColor];
        }else {
            [add setTitle:@"同意添加" forState:UIControlStateNormal];
            _user = [_CellssourceUserId objectAtIndex:indexPath.row];
            NSLog(@"%@",YHuid);
            NSLog(@"%@",_user);
            [add addTarget:self action:@selector(agreeadd) forControlEvents:UIControlEventTouchUpInside];
        }
    return cell;
}

- (void)agreeadd{
    NSLog(@"hello");
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Friend/agreeFriend";
    NSDictionary *lparameters = @{@"uid1":YHuid,@"uid2":_user};
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
                  [self presentAlert:@"请求接受成功!"];
              }else{
                  [self presentAlert:@"已经是好友了!"];
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              [self presentAlert:@"网络错误"];
              
          }];
}

- (void)isfriend:(NSString *)suser :(NSString *)tuser {
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Friend/isFriend";
    NSDictionary *lparameters = @{@"uid1":suser,@"uid2":tuser};
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
                  _isfriend = dict[@"data"];
              }else{
                  NSLog(@"%@",dict);
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
