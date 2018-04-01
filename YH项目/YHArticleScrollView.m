//
//  YHArticleScrollView.m
//  YH项目
//
//  Created by zhujinchi on 16/6/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YHArticleScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YHArticleScrollView()

@property(nonatomic,readwrite)CGFloat totalHeight;
@property(nonatomic,strong)UILabel* titleLab;
@property(nonatomic,strong)UILabel* pubTimeLab;
@property(nonatomic,strong)UILabel* unameLab;
@property(nonatomic,strong)UIWebView* content;
@property(nonatomic,strong) UILabel* rewardLab;
@property(nonatomic,strong) UILabel* collectedLab;
@property(nonatomic,strong) UILabel* popularityLab;
@property(nonatomic,readwrite)UIEdgeInsets edgeInset;
@property(nonatomic,readwrite)CGSize screenSize;
@property(nonatomic,strong) NSMutableArray *urlArray;

@end

@implementation YHArticleScrollView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollEnabled = NO;
        self.alwaysBounceVertical = YES;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        
        self.edgeInset = UIEdgeInsetsMake(5, 5, 5, 5);
        self.backgroundColor = [UIColor clearColor];
        _screenSize = [UIScreen mainScreen].bounds.size;
        
        UILabel *title = [[UILabel alloc] init];
        [self addSubview:title];
        self.titleLab = title;
        
        UILabel *name = [[UILabel alloc] init];
        [self addSubview:name];
        self.unameLab = name;
        
        UILabel *pubTime = [[UILabel alloc] init];
        [self addSubview:pubTime];
        self.pubTimeLab = pubTime;
        
        UILabel *reward = [[UILabel alloc] init];
        [self addSubview:reward];
        self.rewardLab = reward;
        
        UILabel *collected = [[UILabel alloc] init];
        [self addSubview:collected];
        self.collectedLab = collected;
        
        UILabel *popularity = [[UILabel alloc] init];
        [self addSubview:popularity];
        self.popularityLab = popularity;
        
        UIWebView *content = [[UIWebView alloc] init];
        content.delegate = self;
        [self addSubview:content];
        self.content = content;
        
        UIImageView *iconImg = [[UIImageView alloc] init];
        [self addSubview:iconImg];
        self.iconImgView = iconImg;
        [self.iconImgView setUserInteractionEnabled:YES];
        
        self.edgeInset = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return self;
}

-(void)setItemModel:(YHArticlesCellItems *)itemModel{
    _itemModel = itemModel;
    //    [_iconImgView setImage:[UIImage imageNamed:itemModel.icon]];
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",itemModel.avatar]] placeholderImage:[UIImage imageNamed:@"imfomation_icon_default"]];
    [_titleLab setText:itemModel.title];
    [_unameLab setText:itemModel.uname];
    [_pubTimeLab setText:itemModel.pub_time];
    //[_rewardLab setText:[NSString stringWithFormat:@"打赏\n%@",itemModel.awd_num]];
    [_rewardLab setText:[NSString stringWithFormat:@"收藏\n%@",itemModel.col_num]];
    [_popularityLab setText:[NSString stringWithFormat:@"关注\n%@",itemModel.like_num]];
    //[_collectedLab setText:[NSString stringWithFormat:@"收藏\n%@",itemModel.col_num]];
    
//    NSInteger num = [itemModel.awd_num integerValue];
//    if (num>=10000) {
//        CGFloat f = [itemModel.awd_num floatValue];
//        [_rewardLab setText:[NSString stringWithFormat:@"打赏\n%.1fw",f/10000]];
//    }else{
//        [_rewardLab setText:[NSString stringWithFormat:@"打赏\n%@",itemModel.awd_num]];
//    }
//    
//    num = [itemModel.like_num integerValue];
//    if (num>=10000) {
//        CGFloat f = [itemModel.like_num floatValue];
//        [_popularityLab setText:[NSString stringWithFormat:@"关注\n%.1fw",f/10000]];
//    }else{
//        [_popularityLab setText:[NSString stringWithFormat:@"关注\n%@",itemModel.like_num]];
//    }
//    
//    num = [itemModel.col_num integerValue];
//    if (num>=10000) {
//        CGFloat f = [itemModel.col_num floatValue];
//        [_collectedLab setText:[NSString stringWithFormat:@"收藏\n%.1fw",f/10000]];
//    }else{
//        [_collectedLab setText:[NSString stringWithFormat:@"收藏\n%@",itemModel.col_num]];
//    }
}

- (void)drawRect:(CGRect)rect {
    [_titleLab setLineBreakMode:NSLineBreakByWordWrapping];
    _titleLab.numberOfLines = 0;
    [_titleLab setTextAlignment:NSTextAlignmentCenter];
    [_titleLab setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:16.0f]];
    CGSize Size = [_titleLab sizeThatFits:CGSizeMake(_screenSize.width-2*self.edgeInset.left-2*self.edgeInset.right, MAXFLOAT)];
    [_titleLab setFrame:CGRectMake((_screenSize.width-Size.width)/2, 0, Size.width, Size.height)];
    
    [_pubTimeLab setLineBreakMode:NSLineBreakByWordWrapping];
    _pubTimeLab.numberOfLines = 0;
    [_pubTimeLab setTextAlignment:NSTextAlignmentCenter];
    [_pubTimeLab setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:12.0f]];
    Size = [_pubTimeLab sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [_pubTimeLab setFrame:CGRectMake(self.frame.size.width-_edgeInset.left*2, _titleLab.frame.origin.y+ _titleLab.frame.size.height + _edgeInset.top, -Size.width, Size.height)];
    [self addSubview:_pubTimeLab];
    
    [self.iconImgView setFrame:CGRectMake(_edgeInset.left*3,_pubTimeLab.frame.size.height+_pubTimeLab.frame.origin.y+_edgeInset.top,60,60)];
    self.iconImgView.layer.cornerRadius = self.iconImgView.frame.size.width/2;
    self.iconImgView.clipsToBounds = YES;
    self.iconImgView.layer.borderWidth = 0.0f;
    self.iconImgView.layer.borderColor = [UIColor clearColor].CGColor;
    [self addSubview: _iconImgView];
    
    [_unameLab setLineBreakMode:NSLineBreakByWordWrapping];
    _unameLab.numberOfLines = 0;
    [_unameLab setTextAlignment:NSTextAlignmentCenter];
    [_unameLab setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:14.0f]];
    Size = [_unameLab sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [_unameLab setFrame:CGRectMake(_iconImgView.frame.origin.x+_iconImgView.frame.size.width+_edgeInset.left*2, _iconImgView.frame.origin.y + _iconImgView.frame.size.height/2-Size.height/2, Size.width, Size.height)];
    [self addSubview:_unameLab];
    
    Size = CGSizeMake(self.frame.size.width/6 -_edgeInset.left, _iconImgView.frame.size.height);
    
    [_rewardLab setLineBreakMode:NSLineBreakByWordWrapping];
    _rewardLab.numberOfLines = 0;
    [_rewardLab setTextAlignment:NSTextAlignmentCenter];
    [_rewardLab setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:14.0f]];
    [_rewardLab setFrame:CGRectMake(self.frame.size.width-_edgeInset.right*3,_iconImgView.frame.origin.y,-Size.width,Size.height)];
    [self addSubview:_rewardLab];
    
    [_popularityLab setLineBreakMode:NSLineBreakByWordWrapping];
    _popularityLab.numberOfLines = 0;
    [_popularityLab setTextAlignment:NSTextAlignmentCenter];
    [_popularityLab setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:14.0f]];
    [_popularityLab setFrame:CGRectMake(_rewardLab.frame.origin.x,_rewardLab.frame.origin.y,-Size.width,Size.height)];
    [self addSubview:_popularityLab];
    
    [_collectedLab setLineBreakMode:NSLineBreakByWordWrapping];
    _collectedLab.numberOfLines = 0;
    [_collectedLab setTextAlignment:NSTextAlignmentCenter];
    [_collectedLab setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:14.0f]];
    [_collectedLab setFrame:CGRectMake(_popularityLab.frame.origin.x,_popularityLab.frame.origin.y,-Size.width,Size.height)];
    [self addSubview:_collectedLab];
    
    [_content setOpaque:YES];
    [_content setScalesPageToFit:YES];
    [_content setFrame:CGRectMake(2*_edgeInset.left,_iconImgView.frame.origin.y+_iconImgView.frame.size.height+2*_edgeInset.top, _screenSize.width - 2*_edgeInset.left - 2*_edgeInset.right , _screenSize.height - _iconImgView.frame.origin.y-_iconImgView.frame.size.height-2*_edgeInset.top-44-64)];
    NSString *css = @"<style type=\"text/css\"> img {width:100%;height:auto;margin-top:20px;margin-bottom:20px;}body {margin-right:15px;margin-left:15px;margin-top:20px;margin-bottom:20px;font-size:45px;}</style>";
    NSString *html = [NSString stringWithFormat:@"%@%@%@%@%@",@"<html><header>" , css , @"</header><body>" , _itemModel.art_content , @"</body></html>"];
    [_content loadHTMLString:html baseURL:nil];
    [self addSubview:_content];
    
    self.contentSize = CGSizeMake(self.frame.size.width, _content.frame.size.height+_content.frame.origin.y);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入JS方法
    //urlResurlt - 获取到H5页面上所有图片的url的拼接
    NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    //mUrlArray就是所有图片URL的数组
    _urlArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
    if (_urlArray.count >= 2) {
        [_urlArray removeLastObject];
    }
    
    //添加图片可点击JS
    [webView stringByEvaluatingJavaScriptFromString:@"function registerImageClickAction(){\
     var imgs=document.getElementsByTagName('img');\
     var length=imgs.length;\
     for(var i=0;i<length;i++){\
     img=imgs[i];\
     img.onclick=function(){\
     window.location.href='image-preview:'+this.src}\
     }\
     }"];
    [webView stringByEvaluatingJavaScriptFromString:@"registerImageClickAction();"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //预览图片
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString * imgUrl = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        [imgUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        //path 就是被点击图片的url
        [self showSDPhotoBrowser:imgUrl];
        return NO;
    }
    return YES;
}

-(void)showSDPhotoBrowser:(NSString *)imgUrl{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self.superview;
    browser.imageCount = _urlArray.count;
    browser.currentImageIndex = [_urlArray indexOfObject:imgUrl];
    browser.delegate = self;
    [browser show]; // 展示图片浏览器
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    NSString *urlStr = _urlArray[index];
    NSURL *url = [NSURL URLWithString:urlStr];
    return url;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
