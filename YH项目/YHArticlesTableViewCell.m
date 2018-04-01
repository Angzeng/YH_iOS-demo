//
//  ArticlesTableViewCell.m
//  Test
//
//  Created by Zero on 15/11/8.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "YHArticlesTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YHArticlesTableViewCell()


@property(weak, nonatomic) IBOutlet UILabel* titleLab;
@property(weak, nonatomic) IBOutlet UILabel* contentLab;
@property(nonatomic,readwrite) UIEdgeInsets cellEdgeInset;

@end

@implementation YHArticlesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"cell";
    YHArticlesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[YHArticlesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellEdgeInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
        UIImageView *IconImg = [[UIImageView alloc] init];
        [self.contentView addSubview:IconImg];
        self.iconImgView = IconImg;
        [self.iconImgView setUserInteractionEnabled:YES];
        
        UIImageView *btnImg = [[UIImageView alloc] init];
        [self.contentView addSubview:btnImg];
        self.btnImgView = btnImg;
        [self.btnImgView setUserInteractionEnabled:YES];
        
        UILabel *title = [[UILabel alloc] init];
        [self.contentView addSubview:title];
        self.titleLab = title;
        
        UILabel *content = [[UILabel alloc] init];
        [self.contentView addSubview:content];
        self.contentLab = content;
    }
    return self;
}

-(void) setItemModel:(YHArticlesCellItems *)itemModel{
    _itemModel = itemModel;
    self.titleLab.text = itemModel.title;
    self.contentLab.text = [self attributedStringWithHTMLString: itemModel.art_content];
    self.btnImgView.image = [UIImage imageNamed:@"passagecenter_to"];
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",itemModel.avatar]] placeholderImage:[UIImage imageNamed:@"imfomation_icon_default"]];
}

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //裁剪圆角
    CGRect Rect;
    UIBezierPath *maskPath;
    Rect = CGRectMake(self.bounds.origin.x+5, self.bounds.origin.y, self.frame.size.width-20, self.frame.size.height);
    maskPath = [UIBezierPath bezierPathWithRoundedRect:Rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = Rect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    self.backgroundColor = [UIColor whiteColor];
    
    //设置文章标题
    [self.titleLab setFrame:CGRectMake(self.layer.mask.frame.origin.x + 2 * self.cellEdgeInset.left, self.layer.mask.frame.origin.y, self.layer.mask.frame.size.width*5/7, self.layer.mask.frame.size.height/3)];
    self.titleLab.font = [UIFont fontWithName:@"STHeitiTC-Light" size:18.0f];
    self.titleLab.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    self.titleLab.numberOfLines = 1;
    
    //设置按钮
    [self.btnImgView setFrame:CGRectMake(self.layer.mask.frame.origin.x + self.layer.mask.frame.size.width - self.cellEdgeInset.right, self.layer.mask.frame.origin.y , - self.layer.mask.frame.size.height/3, self.layer.mask.frame.size.height/3 )];
    self.btnImgView.layer.cornerRadius = self.btnImgView.frame.size.width/2;
    self.btnImgView.clipsToBounds = YES;
    self.btnImgView.layer.borderWidth = 0.0f;
    self.btnImgView.layer.borderColor = [UIColor clearColor].CGColor;
    
    //绘制直线
    CGPoint cPoint[2];
    cPoint[0] = CGPointMake(Rect.origin.x, Rect.origin.y+Rect.size.height/3);
    cPoint[1] = CGPointMake(Rect.origin.x+Rect.size.width+5, Rect.origin.y+Rect.size.height/3);
    CGContextSetLineWidth(context, 0.5);
    [[UIColor grayColor] setStroke];
    CGContextAddLines(context, cPoint, 2);
    CGContextDrawPath(context, kCGPathStroke);
    
    //设置头像
    [self.iconImgView setFrame:CGRectMake(self.layer.mask.frame.origin.x + self.layer.mask.frame.size.width/7 - self.cellEdgeInset.right/2 -self.layer.mask.frame.size.height/6 ,self.layer.mask.frame.origin.y + self.layer.mask.frame.size.height/2, self.layer.mask.frame.size.height/3, self.layer.mask.frame.size.height/3)];
    self.iconImgView.layer.cornerRadius = self.iconImgView.frame.size.width/2;
    self.iconImgView.clipsToBounds = YES;
    self.iconImgView.layer.borderWidth = 0.0f;
    self.iconImgView.layer.borderColor = [UIColor clearColor].CGColor;
    
    //设置文章内容
    [self.contentLab setFrame:CGRectMake(self.layer.mask.frame.origin.x + self.layer.mask.frame.size.width - self.cellEdgeInset.right, self.layer.mask.frame.origin.y+self.layer.mask.frame.size.height/3,-self.layer.mask.frame.size.width*5/7, self.layer.mask.frame.size.height*2/3)];
    self.contentLab.font = [UIFont fontWithName:@"STHeitiTC-Light" size:12.0f];
    self.contentLab.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    self.contentLab.numberOfLines = 4;
}

//将HTML字符串转化为NSAttributedString富文本字符串
- (NSString *)attributedStringWithHTMLString:(NSString *)htmlString
{
    NSString *pattern = @"<(img|IMG)(.*?)(/>|></img>|>)";
    NSError *error = NULL;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    htmlString = [regular stringByReplacingMatchesInString:htmlString options:NSMatchingReportProgress range:NSMakeRange(0, htmlString.length) withTemplate:@"[图片]"];
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    return attributedString.string;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
