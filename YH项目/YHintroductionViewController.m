//
//  YHintroductionViewController.m
//  YH项目
//
//  Created by Angzeng on 14/09/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "YHintroductionViewController.h"

@interface YHintroductionViewController ()

@end

@implementation YHintroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self crearUI];
    self.navigationItem.title = @"模型介绍";
    // Do any additional setup after loading the view.
}



- (void)crearUI {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-66)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = self.view.frame.size;
    [self.view addSubview:scrollView];
    UIImageView *intro = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (1136*self.view.frame.size.width)/640)];
    intro.image = [UIImage imageNamed:@"introduction"];
    [scrollView addSubview:intro];
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
