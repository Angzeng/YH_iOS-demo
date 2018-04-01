//
//  CheckMessageViewController.m
//  YH项目
//
//  Created by Apple on 2017/6/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CheckMessageViewController.h"
#import "CheckmessageTableViewController.h"

@interface CheckMessageViewController ()

@property (strong , nonatomic) CheckmessageTableViewController *Checkmessagetableview;

@end

@implementation CheckMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"验证信息";
    [self inittableview];
    // Do any additional setup after loading the view.
}

- (void)inittableview {
    _Checkmessagetableview = [[CheckmessageTableViewController alloc] init];
    _Checkmessagetableview.view.frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_Checkmessagetableview.view];
    self.Checkmessagetableview = _Checkmessagetableview;
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
