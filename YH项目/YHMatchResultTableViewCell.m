//
//  YHResultViewCell.m
//  YH项目
//
//  Created by Apple on 16/3/15.
//  Copyright (c) 2016年 Apple. All rights reserved.
//

#import "YHMatchResultTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define PI 3.14159265358979323846

@interface YHMatchResultTableViewCell()

@property(nonatomic,readwrite) UIEdgeInsets cellEdgeInset;
@property(nonatomic,strong) UIImageView *iconImgView;
@property(nonatomic,strong) UIImageView *unameImgView;
@property(nonatomic,strong) UILabel *unameLabel;
@property(nonatomic,strong) UIImageView *signImgView;
@property(nonatomic,strong) UILabel *signLabel;
@property(nonatomic,strong) UIImageView *simiImgView;
@property(nonatomic,strong) UILabel *simiLabel;
@property(nonatomic,readwrite) CGFloat data;
//@property(nonatomic,strong) UIView *

@end

@implementation YHMatchResultTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"cell";
    YHMatchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[YHMatchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellEdgeInset = UIEdgeInsetsMake(8, 8, 8, 8);
        
        UIImageView *iconImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImgView];
        self.iconImgView = iconImgView;
        
        UIImageView *unameImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:unameImgView];
        self.unameImgView = unameImgView;
        
        UIImageView *signImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:signImgView];
        self.signImgView = signImgView;
        
        UIImageView *simiImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:simiImgView];
        self.simiImgView = simiImgView;
        
        UILabel *uname = [[UILabel alloc] init];
        [self.contentView addSubview:uname];
        self.unameLabel = uname;
        
        UILabel *sign = [[UILabel alloc] init];
        [self.contentView addSubview:sign];
        self.signLabel = sign;
        
        UILabel *simi = [[UILabel alloc] init];
        [self.contentView addSubview:simi];
        self.simiLabel = simi;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //头像
    [self.iconImgView setFrame:CGRectMake(self.cellEdgeInset.left, self.cellEdgeInset.top, self.frame.size.height-self.cellEdgeInset.top-self.cellEdgeInset.bottom, self.frame.size.height-self.cellEdgeInset.top-self.cellEdgeInset.bottom)];
    self.iconImgView.layer.cornerRadius = self.iconImgView.frame.size.width/2;
    self.iconImgView.clipsToBounds = YES;
    self.iconImgView.layer.borderWidth = 0;
    self.iconImgView.layer.borderColor = [UIColor clearColor].CGColor;
    
    //名字
    [self.unameImgView setFrame:CGRectMake(self.frame.size.height+self.cellEdgeInset.left+self.iconImgView.frame.size.width*0.1/2 , self.iconImgView.frame.size.width*0.1/2+self.cellEdgeInset.top, self.iconImgView.frame.size.width/2*0.8, self.iconImgView.frame.size.width/2*0.8)];
    self.unameImgView.layer.cornerRadius = self.unameImgView.frame.size.width/2;
    self.unameImgView.clipsToBounds = YES;
    self.unameImgView.layer.borderWidth = 0;
    self.unameImgView.layer.borderColor = [UIColor clearColor].CGColor;
    
    //签名
    [self.signImgView setFrame:CGRectMake(self.frame.size.height+self.cellEdgeInset.left+self.iconImgView.frame.size.width*0.1/2, self.frame.size.height - self.iconImgView.frame.size.width*0.1/2-self.cellEdgeInset.bottom, self.iconImgView.frame.size.width/2*0.8, -self.iconImgView.frame.size.width/2*0.8)];
    self.signImgView.layer.cornerRadius = self.signImgView.frame.size.width/2;
    self.signImgView.clipsToBounds = YES;
    self.signImgView.layer.borderWidth = 0;
    self.signImgView.layer.borderColor = [UIColor clearColor].CGColor;
    
    [self.simiLabel setFrame:CGRectMake(self.frame.size.width - self.frame.size.height,0,self.frame.size.height ,self.frame.size.height)];
    
    [self.unameLabel setFrame:CGRectMake(self.frame.size.height+self.cellEdgeInset.left+self.iconImgView.frame.size.width/2+3, self.cellEdgeInset.top, self.frame.size.width-self.frame.size.height-self.cellEdgeInset.left-self.iconImgView.frame.size.width/2+self.simiLabel.frame.origin.x-self.frame.size.width-3, self.iconImgView.frame.size.width/2)];
    
    [self.signLabel setFrame:CGRectMake(self.frame.size.height+self.cellEdgeInset.left+self.iconImgView.frame.size.width/2+3, self.frame.size.height-self.cellEdgeInset.bottom, self.frame.size.width-self.frame.size.height-self.cellEdgeInset.left-self.iconImgView.frame.size.width/2+self.simiLabel.frame.origin.x-self.frame.size.width-3, -self.iconImgView.frame.size.width/2)];
}

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[self backgroundColor] CGColor]);
    CGContextFillRect(context, rect);
    
    //绘制直线
    CGPoint aPoints[2];
    aPoints[0] = CGPointMake(self.frame.size.height, self.cellEdgeInset.top);
    aPoints[1] = CGPointMake(self.frame.size.height, self.frame.size.height - self.cellEdgeInset.top);
    CGContextSetLineWidth(context, 0.5);
    CGContextAddLines(context, aPoints, 2);
    CGContextClosePath(context);
    [[UIColor grayColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
    
    //绘制圆形
    CGContextAddArc(context,self.frame.size.width - self.frame.size.height/2, self.frame.size.height/2, self.frame.size.height/2 -self.cellEdgeInset.top, 0, 2*PI, 0);
    CGContextClosePath(context);
    [[UIColor grayColor] setFill];
    CGContextDrawPath(context, kCGPathFill);
    
    //绘制扇形
    CGContextMoveToPoint(context,self.frame.size.width - self.frame.size.height/2, self.frame.size.height/2);
    CGContextAddArc(context,self.frame.size.width - self.frame.size.height/2, self.frame.size.height/2, self.frame.size.height/2-self.cellEdgeInset.top-4, (-0.25)*2*PI, _data/100*2*PI+(-0.25)*2*PI, 0);
    CGContextClosePath(context);
    [[UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0] setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void) setItemModel{
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",_itemModel.avatar]] placeholderImage:[UIImage imageNamed:@"imfomation_icon_default"]];
    self.unameImgView.image = [UIImage imageNamed:@"imfomation_icon_profile"];
    self.signImgView.image = [UIImage imageNamed:@"imfomation_icon_intoduction"];
    
    self.unameLabel.text = _itemModel.uname;
    self.unameLabel.backgroundColor = [UIColor whiteColor];
    self.unameLabel.textColor = [UIColor blackColor];
    self.unameLabel.textAlignment = NSTextAlignmentLeft;
    self.unameLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:12.0f];
    
    self.signLabel.text = _itemModel.introduce;
    self.signLabel.backgroundColor = [UIColor whiteColor];
    self.signLabel.textColor = [UIColor blackColor];
    self.signLabel.textAlignment = NSTextAlignmentLeft;
    self.signLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:12.0f];
    
    if (_itemModel.similar) {
        _data = [_itemModel.similar doubleValue]*100;
        self.simiLabel.text = [NSString stringWithFormat:@"%0.1lf%%\n相似度",_data];
    }else{
        _data = [_itemModel.difference doubleValue]*100;
        self.simiLabel.text = [NSString stringWithFormat:@"%0.1lf%%\n相异度",_data];
    }
    self.simiLabel.backgroundColor = [UIColor clearColor];
    self.simiLabel.textColor = [UIColor whiteColor];
    self.simiLabel.numberOfLines = 2;
    self.simiLabel.textAlignment = NSTextAlignmentCenter;
    self.simiLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:12.0f];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
