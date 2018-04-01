//
//  YHTabBarController.m
//  YH项目
//
//  Created by 渡。 on 2017/6/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YHTabBarController.h"
#import "YHArticlesCenterViewController.h"
#import "YHSearchViewController.h"
#import "YHmemberMainViewController.h"
#import "GRZXmainController.h"

@interface YHTabBarController ()

@end

@implementation YHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[UITabBar appearance] setShadowImage:[self createImageWithColor:[UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:0.3]]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    //[[UITabBar appearance] setTranslucent:NO];
    
    [[UINavigationBar appearance] setTranslucent:NO];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //
    //    文章
    YHArticlesCenterViewController *articlesCenter = [[YHArticlesCenterViewController alloc] init];
    UINavigationController * vc1 = [[UINavigationController alloc] initWithRootViewController:articlesCenter];
    vc1.view.backgroundColor = [UIColor whiteColor];
    vc1.tabBarItem.image = [UIImage imageNamed:@"tabbar_passagecenter"];
    // 声明：这张图片按照原始的样子显示出来，不要自动渲染成其他颜色（比如蓝色）
    vc1.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_passagecenter_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc1.tabBarItem.title = @"贵人说";
    dict[NSForegroundColorAttributeName] = [UIColor redColor];
    [vc1.tabBarItem setTitleTextAttributes:dict forState:UIControlStateSelected];
    //vc1.tabBarItem.imageInsets=UIEdgeInsetsMake(6, 0,-6, 0);
    
    //搜索
    YHSearchViewController *searchView = [[YHSearchViewController alloc] init];
    UINavigationController *vc2 = [[UINavigationController alloc] initWithRootViewController:searchView];
    vc2.view.backgroundColor = [UIColor whiteColor];
    vc2.tabBarItem.image = [UIImage imageNamed:@"tabbar_discover"];
    // 声明：这张图片按照原始的样子显示出来，不要自动渲染成其他颜色（比如蓝色）
    vc2.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_discover_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc2.tabBarItem.title = @"财贵人";
    dict[NSForegroundColorAttributeName] = [UIColor redColor];
    [vc2.tabBarItem setTitleTextAttributes:dict forState:UIControlStateSelected];
    //vc2.tabBarItem.imageInsets=UIEdgeInsetsMake(6, 0,-6, 0);
    
    
    //成员
    YHmemberMainViewController *memberView = [[YHmemberMainViewController alloc]init];
    //        loginViewController *loginVC = [[loginViewController alloc]init];
    UINavigationController *vc3 = [[UINavigationController alloc]initWithRootViewController:memberView];
    //[vc3.navigationBar setBackgroundColor:[UIColor greenColor]];
    //        vc3.navigationBar.barStyle = UIBarStyleBlack;
    vc3.tabBarItem.image = [UIImage imageNamed:@"tabbar_home"];
    // 声明：这张图片按照原始的样子显示出来，不要自动渲染成其他颜色（比如蓝色）
    vc3.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc3.tabBarItem.title = @"孕富圈";
    dict[NSForegroundColorAttributeName] = [UIColor redColor];
    [vc3.tabBarItem setTitleTextAttributes:dict forState:UIControlStateSelected];
    //vc3.tabBarItem.imageInsets=UIEdgeInsetsMake(6, 0,-6, 0);
    
    //个人中心
    UIStoryboard *story4 = [UIStoryboard storyboardWithName:@"main4" bundle:[NSBundle mainBundle]];
    GRZXmainController *vc4 =  [story4 instantiateViewControllerWithIdentifier:@"forth"];
    vc4.view.backgroundColor = [UIColor whiteColor];
    vc4.tabBarItem.image = [UIImage imageNamed:@"tabbar_profile"];
    // 声明：这张图片按照原始的样子显示出来，不要自动渲染成其他颜色（比如蓝色）
    vc4.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_profile_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc4.tabBarItem.title = @"个人";
    dict[NSForegroundColorAttributeName] = [UIColor redColor];
    [vc4.tabBarItem setTitleTextAttributes:dict forState:UIControlStateSelected];
    
    self.viewControllers = @[vc2,vc1,vc3,vc4];
    
    // Do any additional setup after loading the view.
}

- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)viewWillLayoutSubviews{
    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
    NSLog(@"%f",49*[UIScreen mainScreen].bounds.size.height/568);
    tabFrame.size.height = 49*[UIScreen mainScreen].bounds.size.height/568;
    tabFrame.origin.y = self.view.frame.size.height - 49*[UIScreen mainScreen].bounds.size.height/568;
    self.tabBar.frame = tabFrame;
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
