//
//  YHArticleViewController.m
//  YH项目
//
//  Created by zhujinchi on 16/6/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YHArticleViewController.h"
#import "YHArticlesCellItems.h"
#import "YHInfoPopViewController.h"
#import "YHInfoPopViewPresentationController.h"
#import "YHCommentViewController.h"
#import "YHInfoPopView.h"
#import "YHLoginViewController.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <MJExtension/MJExtension.h>

@interface YHArticleViewController ()<UIViewControllerTransitioningDelegate,YHInfoPopViewHandler>

@property(nonatomic,readwrite)CGSize screenSize;
@property(nonatomic,strong) UIButton* commentButton;
@property(nonatomic,strong) UIButton* rewardButton;
@property(nonatomic,strong) UIButton* collectedButton;
@property(nonatomic,strong) UIButton* popularityButton;
@property(nonatomic,strong) UIAlertView *alert;
@property(nonatomic,strong) YHInfoPopView *poper;
@property(nonatomic,readwrite) NSString *focusType;
@property(nonatomic,readwrite) NSString *collectType;
@property(nonatomic,readwrite) int *change;
@property(nonatomic,readwrite) CGFloat height;

@end

@implementation YHArticleViewController

-(id)initWithItems:(YHArticlesCellItems *)itemModel{
    self = [super init];
    if (self) {
        _height = 48;
        _screenSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
        YHArticleScrollView *scrollView = [[YHArticleScrollView alloc] initWithFrame:CGRectMake(0, 0, _screenSize.width, _screenSize.height-_height)];
        self.articleScrollView = scrollView;
        _articleScrollView.itemModel = itemModel;
        UITapGestureRecognizer *gesture_info;
        gesture_info = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoTap:)];
        [_articleScrollView.iconImgView addGestureRecognizer:gesture_info];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_articleScrollView];
    _change = malloc(5*sizeof(int));
    for (int i=0; i<5; i++) {
        *(_change+i) = 0;
    }
    _change[0] = 1;
    [self setButton];
    _focusType = @"3";
    _collectType = @"3";
    [self focusAuthor];
    [self collectArticle];
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{
    for (int i=0; i<5; i++) {
        if (*(_change+i)) {
            [self saveData];
            break;
        }
    }
}

-(void)saveData{
    NSDictionary *dict = @{@"view_num":[NSString stringWithFormat:@"%d",*(_change)],@"like_num":[NSString stringWithFormat:@"%d",*(_change+1)],@"awd_num":[NSString stringWithFormat:@"%d",*(_change+2)],@"col_num":[NSString stringWithFormat:@"%d",*(_change+3)],@"com_num":[NSString stringWithFormat:@"%d",*(_change+4)]};
    NSString *urlStr = @"http://zhujinchi.com/index.php/Mobile/ArticleUpdate/articleUpdate";
    NSDictionary *parameters = @{@"change":dict,@"aid":self.articleScrollView.itemModel.aid};
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
              NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
              if ([code isEqualToString:@"200"]) {
                  for (int i=0; i<5; i++) {
                      *(_change+i) = 0;
                  }
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
          }];
}

-(void) setButton{
//    CGSize size = CGSizeMake(44 , 44);
    self.commentButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _screenSize.height, _screenSize.width/4, -_height)];
    [self.commentButton setImage:[UIImage imageNamed:@"commentbar_comment"] forState:UIControlStateNormal];
//    [self.commentButton setImageEdgeInsets:UIEdgeInsetsMake(0,_screenSize.width/8-size.width/2,20,_screenSize.width/8-size.width/2)];
////    [self.commentButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.commentButton.backgroundColor = [UIColor whiteColor];
    self.commentButton.adjustsImageWhenHighlighted = NO;
//    [self.commentButton setTitle:@"评论" forState:UIControlStateNormal];
//    self.commentButton.titleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:12.0f];
//    self.commentButton.titleLabel.textAlignment = NSTextAlignmentLeft;
//    [self.commentButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
//    self.commentButton.titleEdgeInsets = UIEdgeInsetsMake(44,_screenSize.width/8-size.width/2,0,_screenSize.width/8-size.width/2);
//    self.commentButton.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.commentButton addTarget:self action:@selector(accessComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commentButton];
    
    self.popularityButton = [[UIButton alloc] initWithFrame:CGRectMake(_screenSize.width/4, _screenSize.height, _screenSize.width/4, -_height)];
    [self.popularityButton setImage:[UIImage imageNamed:@"commentbar_attention_unchoosed"] forState:UIControlStateNormal];
    self.popularityButton.backgroundColor = [UIColor whiteColor];
    self.popularityButton.adjustsImageWhenHighlighted = NO;
    [self.popularityButton addTarget:self action:@selector(focusAuthor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_popularityButton];
    
    self.collectedButton = [[UIButton alloc] initWithFrame:CGRectMake(_screenSize.width/2, _screenSize.height, _screenSize.width/4, -_height)];
    [self.collectedButton setImage:[UIImage imageNamed:@"commentbar_collect_unchoosed"] forState:UIControlStateNormal];
    self.collectedButton.backgroundColor = [UIColor whiteColor];
    self.collectedButton.adjustsImageWhenHighlighted = NO;
    [self.collectedButton addTarget:self action:@selector(collectArticle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_collectedButton];
    
    self.rewardButton = [[UIButton alloc] initWithFrame:CGRectMake(_screenSize.width*3/4, _screenSize.height, _screenSize.width/4, -_height)];
    [self.rewardButton setImage:[UIImage imageNamed:@"commentbar_money"] forState:UIControlStateNormal];
    self.rewardButton.backgroundColor = [UIColor whiteColor];
    [self.rewardButton addTarget:self action:@selector(returnview) forControlEvents:UIControlEventTouchUpInside];
    self.rewardButton.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:_rewardButton];
}

//
-(void)returnview {
    [self.navigationController popViewControllerAnimated:YES];
}
//

-(void)accessComment{
    YHCommentViewController *comment = [[YHCommentViewController alloc] init];
    comment.aid = _articleScrollView.itemModel.aid;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:comment action: nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    comment.hidesBottomBarWhenPushed = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1]];
    [self.navigationController pushViewController:comment animated:YES];
}

- (void) infoTap:(UIGestureRecognizer *) sender{
    YHInfoPopViewController *popViewController = [[YHInfoPopViewController alloc] init];
    popViewController.UID = _articleScrollView.itemModel.uid;
    self.definesPresentationContext = YES;
    popViewController.modalPresentationStyle = UIModalPresentationCustom;
    popViewController.transitioningDelegate = self;
    popViewController.InfoPopViewHandlerDelegate = self;
    [self presentViewController:popViewController animated:NO completion:^{
    }];
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    return [[YHInfoPopViewPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    
}

-(id)getNavigationController{
    return [self navigationController];
}

-(void)collectArticle{
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Collect/collect";
    NSDictionary *parameters = @{@"type":_collectType,@"aid":self.articleScrollView.itemModel.aid,@"uid":YHuid};
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
              NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
              if ([code isEqualToString:@"200"]) {
                  [self changeCollectInfo];
                  if ([_collectType isEqualToString:@"3"]) {
                      _collectType = @"2";
                  }else{
                      if ([_collectType isEqualToString:@"1"]) {
                          [self presentAlert:@"收藏成功"];
                          _collectType = @"2";
                      }else{
                          [self presentAlert:@"取消成功"];
                          _collectType = @"1";
                      }
                  }
              }else{
                  if([_collectType isEqualToString:@"3"]) {
                      _collectType = @"1";
                  }else{
                      if ([_collectType isEqualToString:@"1"]) {
                          [self presentAlert:@"收藏失败"];
                      }else{
                          [self presentAlert:@"取消失败"];
                      }
                  }
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              if (![_collectType isEqualToString:@"3"]) {
                  [self presentAlert:@"网络错误"];
              }
          }];
}

-(void)changeCollectInfo{
    NSUInteger num = [self.articleScrollView.itemModel.col_num integerValue];
    if ([_collectType isEqualToString:@"2"]) {
        if (num > 0) {
            num -= 1;
            _change[3] -= 1;
        }
        [self.collectedButton setImage:[UIImage imageNamed:@"commentbar_collect_unchoosed"] forState:UIControlStateNormal];
    }else{
        [self.collectedButton setImage:[UIImage imageNamed:@"commentbar_collect_choosed"]  forState:UIControlStateNormal];
        if ([_collectType isEqualToString:@"1"]) {
            _change[3] += 1;
            num += 1;
        }
    }
    self.articleScrollView.itemModel.col_num = [NSString stringWithFormat:@"%lu",(long)num];
    [self.articleScrollView setItemModel:_articleScrollView.itemModel];
}

-(void)focusAuthor{
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/Focus/focus";
    NSDictionary *parameters = @{@"type":_focusType,@"uid2":self.articleScrollView.itemModel.uid,@"uid1":YHuid};
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
              NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
              if ([code isEqualToString:@"200"]) {
                  [self changeFocusInfo];
                  if ([_focusType isEqualToString:@"3"]) {
                      _focusType = @"2";
                  }else{
                      if ([_focusType isEqualToString:@"1"]) {
                          [self presentAlert:@"关注成功"];
                          _focusType = @"2";
                      }else{
                          [self presentAlert:@"取消成功"];
                          _focusType = @"1";
                      }
                  }
              }else{
                  if ([_focusType isEqualToString:@"3"]) {
                      _focusType = @"1";
                  }else{
                      if ([_focusType isEqualToString:@"1"]) {
                          [self presentAlert:@"关注失败"];
                      }else{
                          [self presentAlert:@"取消失败"];
                      }
                  }
              }
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              if (![_focusType isEqualToString:@"3"]) {
                  [self presentAlert:@"网络错误"];
              }
          }];
}

-(void)changeFocusInfo{
    NSUInteger num = [self.articleScrollView.itemModel.like_num integerValue];
    if ([_focusType isEqualToString:@"2"]) {
        if (num > 0) {
            num -= 1;
            _change[1] -= 1;
        }
        [self.popularityButton setImage:[UIImage imageNamed:@"commentbar_attention_unchoosed"] forState:UIControlStateNormal];
    }else{
        [self.popularityButton setImage:[UIImage imageNamed:@"commentbar_attention_choosed"] forState:UIControlStateNormal];
        if ([_focusType isEqualToString:@"1"]) {
            _change[1] += 1;
            num += 1;
        }
    }
    self.articleScrollView.itemModel.like_num = [NSString stringWithFormat:@"%lu",(long)num];
    [self.articleScrollView setItemModel:_articleScrollView.itemModel];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
