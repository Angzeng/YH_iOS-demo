//
//  YHCelebrityTableViewCell.m
//  YH项目
//
//  Created by zhujinchi on 16/7/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YHCelebrityTableViewCell.h"

@interface YHCelebrityTableViewCell()

@property(nonatomic,readwrite) UIEdgeInsets cellEdgeInset;
@property(nonatomic,strong) UIImageView *leftImgView;
@property(nonatomic,strong) UILabel *unameLab;
@property(nonatomic,strong) UIImageView *rightImgView;

@end

@implementation YHCelebrityTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"cell";
    YHCelebrityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[YHCelebrityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellEdgeInset = UIEdgeInsetsMake(8, 8, 8, 8);
        
        UIImageView *leftImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:leftImgView];
        self.leftImgView = leftImgView;
        
        UIImageView *rightImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:rightImgView];
        self.rightImgView = rightImgView;
        
        UILabel *uname = [[UILabel alloc] init];
        [self.contentView addSubview:uname];
        self.unameLab = uname;
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制直线
    CGPoint aPoints[2];
    aPoints[0] = CGPointMake(self.frame.size.height, self.cellEdgeInset.top);
    aPoints[1] = CGPointMake(self.frame.size.height, self.frame.size.height - self.cellEdgeInset.top);
    CGContextSetLineWidth(context, 0.5);
    CGContextAddLines(context, aPoints, 2);
    CGContextClosePath(context);
    [[UIColor grayColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
    
    //leftView
    [self.leftImgView setFrame:CGRectMake(self.cellEdgeInset.left, self.cellEdgeInset.top, self.frame.size.height-self.cellEdgeInset.top-self.cellEdgeInset.bottom, self.frame.size.height-self.cellEdgeInset.top-self.cellEdgeInset.bottom)];
    self.leftImgView.layer.cornerRadius = self.leftImgView.frame.size.width/2;
    self.leftImgView.clipsToBounds = YES;
    self.leftImgView.layer.borderWidth = 0;
    self.leftImgView.layer.borderColor = [UIColor clearColor].CGColor;
    [self.leftImgView setImage:[UIImage imageNamed:@"pick_icon_3"]];
    
    //rightView
    [self.rightImgView setFrame:CGRectMake(self.frame.size.width-self.cellEdgeInset.right, self.cellEdgeInset.top, -50, self.leftImgView.frame.size.height)];
    [self.rightImgView setImage:[UIImage imageNamed:@"pick-rich"]];
    
    //unameLab
    self.unameLab.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16.0];
    [_unameLab setTextAlignment:NSTextAlignmentLeft];
    CGSize size = [_unameLab sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [_unameLab setFrame:CGRectMake(self.frame.size.height+self.cellEdgeInset.left, self.cellEdgeInset.top+self.leftImgView.frame.size.height/2-size.height/2, self.frame.size.width-_leftImgView.frame.size.width-_rightImgView.frame.size.width, size.height)];
}

- (void) setItemModel{
    self.unameLab.text = _itemModel.uname;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
