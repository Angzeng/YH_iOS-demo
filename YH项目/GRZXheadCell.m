//
//  GRZXheadCell.m
//  个人中心
//
//  Created by Apple on 15/11/7.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "GRZXheadCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GRZXmainController.h"
#import "YHLoginViewController.h"
#import "AFNetworking.h"

@interface GRZXheadCell ()

@property (nonatomic, strong) NSString *iconavater;




- (IBAction)editBtnClick:(id)sender;

@end

@implementation GRZXheadCell

-(void)setUser:(GRZXuser *)user{

    _user = user;
    
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/User/user";
    NSDictionary *parameters = @{@"uid":YHuid};
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
              
              _iconavater = dict[@"data"][0][@"avatar"];
              UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 80, 80)];
              [iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",_iconavater]] placeholderImage:[UIImage imageNamed:@"imfomation_icon_default"]];
              
              [self addSubview:iconView];

              
              
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              
          }];
    
}

- (void)awakeFromNib {
    NSLog(@"helloworld");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)editBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goEditViewWithCell:)]) {
        [self.delegate goEditViewWithCell:self];
    }
}
@end
