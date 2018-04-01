//
//  GRZXtreaPageViewController.m
//  个人中心
//
//  Created by lab on 15/10/31.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "GRZXtreaPageViewController.h"
#import  "GRZXpayCell.h"

@interface GRZXtreaPageViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *paytableview;

@end

@implementation GRZXtreaPageViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 2;
    }else{
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 250;
    }else{
        return 44;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ID = [NSString stringWithFormat:@"row_sell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (indexPath.section == 0) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GRZXTpayHeadCell" owner:nil options:nil] firstObject];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
    }
    else if(indexPath.section == 1){
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
         }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"支出列表";
        }else{
            cell.textLabel.text = @"转入列表";
        }

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GRZXpayCell" owner:nil options:nil] firstObject];
        cell.backgroundColor = [UIColor clearColor];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
    }
    return cell;
}

- (IBAction)addpayButton:(UIButton *)sender {
    //NSLog(@"要进入支付页面了啊!");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.navigationItem.title= @"我的财富";
    
    //CGRect screen = [UIScreen mainScreen].bounds;
    
    
    // Do any additional setup after loading the view.
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
