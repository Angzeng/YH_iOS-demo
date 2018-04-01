//
//  YHfriendListTableViewController.m
//  YH项目
//
//  Created by Angzeng on 20/07/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "YHfriendListTableViewController.h"
#import "YHConversationCell.h"
#import "AFNetworking.h"
#import "YHLoginViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YHmemberMainViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>


@interface YHfriendListTableViewController ()

@property (nonatomic , strong) NSMutableArray *CellsItems;
@property (nonatomic , readwrite) NSInteger numberofsection;
@property (nonatomic , strong) NSString *celltargetname;
@property (nonatomic , strong) NSString *celltargetid;
@property (nonatomic , readwrite) NSInteger cellType;
//@property (nonatomic , strong) NSMutableArray *cellimage;
//@property (nonatomic , strong) NSMutableArray *celltargetid;
//@property (nonatomic , strong) NSMutableArray *celltargetname;

@end

@implementation YHfriendListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getfriendlist];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getfriendlist];
        [self endRefresh];
    }];
    self.tableView.mj_header = header;
}

-(void) endRefresh{
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
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
    //
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _cellType = 1;
    YHConversationType = _cellType;
    YHConversationTargetId = [[_CellsItems objectAtIndex:indexPath.row] objectForKey:@"uid"];
    YHConversationTitle = [[_CellsItems objectAtIndex:indexPath.row] objectForKey:@"uname"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"loadconversation" object:self];    
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
