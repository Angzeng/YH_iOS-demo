//
//  GRZXsettingPageViewController.m
//  个人中心
//
//  Created by Apple on 15/10/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "GRZXsettingPageViewController.h"
#import "GRZXquitBtnTableViewCell.h"
#import "YHLoginViewController.h"


@interface GRZXsettingPageViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIAlertView *exitalert;

@end

@implementation GRZXsettingPageViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 1;
    }
}
//  这个地方的代码需要优化；！！！！！！！！！！！！！！！！！！！！！！！！
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

     //多个可重用ID；
    NSString *ID = [[NSString alloc] initWithFormat:@"set%ld",(long)indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(indexPath.section == 0 ){
        if ( cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //自定义版本label
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        lab.font = [UIFont systemFontOfSize:18];
        lab.backgroundColor = [UIColor clearColor];
        lab.userInteractionEnabled = YES;
        lab.text = @"1.0";
        lab.textColor = [UIColor grayColor];
        cell.textLabel.text= @"版本号";
        cell.userInteractionEnabled = NO;
        cell.accessoryView = lab;
        }
    }else{
        _screenWidth = [UIScreen mainScreen].bounds.size.width;//获取屏幕大小
        _screenHeight = [UIScreen mainScreen].bounds.size.height;

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        //
        
        UIButton *quit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        quit.frame = CGRectMake(40, 100, _screenWidth-80, 44);
        quit.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
        [quit setTitle:@"用户退出登录" forState:UIControlStateNormal];
        [quit setTitle:@"用户退出登录" forState:UIControlStateHighlighted];
        [quit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [quit addTarget:self action:@selector(quitclicked:) forControlEvents:UIControlEventTouchUpInside];

        
        [self.tableView addSubview:quit];
        

    }

//    我换一个退出按钮啊冬勋。
//    else{
//         cell = [[[NSBundle mainBundle] loadNibNamed:@"GRZXquitBtnTableViewCell" owner:nil options:nil] firstObject];
//         cell.backgroundColor = [UIColor clearColor];
//         cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
//    }
    
    return cell;

}

-(void)updateSwitch{
}

- (void)quitclicked:(id)sender {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:nil forKey:@"useraccount"];
    [user setObject:nil forKey:@"userpassword"];
    
    
    //-----------清除xmppStream登录时的帐号和密码在本地的缓存--------------
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:nil forKey:@"username"];
    [userDefault setObject:nil forKey:@"password"];
    [userDefault synchronize];//同步到磁盘当中，但不是必须的
    //-----------清除xmppStream登录时的帐号和密码在本地的缓存--------------
    
    _exitalert=[[UIAlertView alloc]initWithTitle:@"用户退出登录" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
    [_exitalert show];

    [[UINavigationBar appearance] setTranslucent:YES];
    YHLoginViewController *next = [[YHLoginViewController alloc]init];
    UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:next];
    [UIApplication sharedApplication].keyWindow.screen = [UIScreen mainScreen];
    [self presentViewController:naVC animated:YES completion:nil];
}

-(void) performDismiss:(NSTimer *)timer
{
    [_exitalert dismissWithClickedButtonIndex:0 animated:NO];
    //    [_registeralert release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title= @"设置";
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
