//
//  GRZXaboutPageViewController.m
//  个人中心
//
//  Created by Apple on 15/10/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "GRZXaboutPageViewController.h"

@interface GRZXaboutPageViewController ()

@end

@implementation GRZXaboutPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title= @"APP说明";
    _abouttext=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-60, 50)];
    UILabel*about=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-60, 50)];
    //显示文字
    about.text=@"这是一份关于APP的说明";
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
