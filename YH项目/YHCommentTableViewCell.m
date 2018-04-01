//
//  YHCommentTableViewCell.m
//  YH项目
//
//  Created by zhujinchi on 16/7/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YHCommentTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YHCommentTableViewCell()

@property(weak, nonatomic) IBOutlet UILabel* unameLab;
@property(weak, nonatomic) IBOutlet UILabel* contentLab;
@property(weak, nonatomic) IBOutlet UILabel* pubTimeLab;
@property(nonatomic,readwrite) UIEdgeInsets edgeInset;

@end

@implementation YHCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"cell";
    YHCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[YHCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.edgeInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
        UIImageView *IconImg = [[UIImageView alloc] init];
        [self.contentView addSubview:IconImg];
        self.iconImgView = IconImg;
        [self.iconImgView setUserInteractionEnabled:YES];
        
        UILabel *uname = [[UILabel alloc] init];
        [self.contentView addSubview:uname];
        self.unameLab = uname;
        
        UILabel *content = [[UILabel alloc] init];
        [self.contentView addSubview:content];
        self.contentLab = content;
        
        UILabel *pubTime = [[UILabel alloc] init];
        [self.contentView addSubview:pubTime];
        self.pubTimeLab = pubTime;
    }
    return self;
}

-(void) setItemModel:(YHCommentCellItems *)itemModel{
    _itemModel = itemModel;
    self.unameLab.text = itemModel.uname;
    self.contentLab.text = itemModel.com_content;
    self.pubTimeLab.text = itemModel.com_time;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",itemModel.avatar]] placeholderImage:[UIImage imageNamed:@"imfomation_icon_default"]];
    
     [self.iconImgView setFrame:CGRectMake(_edgeInset.left*2,_edgeInset.top*2,36,36)];
    
    [_contentLab setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:15.0f]];
    [_contentLab setTextAlignment:NSTextAlignmentLeft];
    [_contentLab setLineBreakMode:NSLineBreakByWordWrapping];
    _contentLab.numberOfLines = 0;
    CGSize size = [_contentLab sizeThatFits:CGSizeMake(self.frame.size.width-2*self.edgeInset.left-2*self.edgeInset.right, MAXFLOAT)];
    [_contentLab setFrame:CGRectMake(2*self.edgeInset.left, _iconImgView.frame.origin.y+_iconImgView.frame.size.height+2*self.edgeInset.top, size.width, size.height)];
    
    self.totalHeight = _contentLab.frame.origin.y + _contentLab.frame.size.height;
}

-(void)drawRect:(CGRect)rect{
    CGSize iconSize = CGSizeMake(36, 36);
    [self.iconImgView setFrame:CGRectMake(_edgeInset.left*2,_edgeInset.top,iconSize.width,iconSize.height)];
    self.iconImgView.layer.cornerRadius = self.iconImgView.frame.size.width/2;
    self.iconImgView.clipsToBounds = YES;
    self.iconImgView.layer.borderWidth = 0.0f;
    self.iconImgView.layer.borderColor = [UIColor clearColor].CGColor;
    
    self.unameLab.font = [UIFont fontWithName:@"STHeitiTC-Light" size:15.0];
    [_unameLab setTextAlignment:NSTextAlignmentCenter];
    [_unameLab setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize size = [_unameLab sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [_unameLab setFrame:CGRectMake(self.iconImgView.frame.origin.x+iconSize.width+_edgeInset.left, self.iconImgView.frame.origin.y, size.width, size.height)];
    
    self.pubTimeLab.font = [UIFont fontWithName:@"STHeitiTC-Light" size:11.0];
    [_pubTimeLab setTextAlignment:NSTextAlignmentCenter];
    [_pubTimeLab setLineBreakMode:NSLineBreakByWordWrapping];
    size = [_pubTimeLab sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [_pubTimeLab setFrame:CGRectMake(_unameLab.frame.origin.x, self.iconImgView.frame.origin.y+self.iconImgView.frame.size.height, size.width+5, -size.height)];
}

-(void) setTag:(NSInteger)tag{
    self.unameLab.tag = tag+1;
    self.contentLab.tag = tag+2;
    self.pubTimeLab.tag = tag+3;
    self.iconImgView.tag = tag+4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
