//
//  YHArticleScrollView.h
//  YH项目
//
//  Created by zhujinchi on 16/6/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHArticlesCellItems.h"
#import "SDPhotoBrowser.h"

@interface YHArticleScrollView : UIScrollView<UIWebViewDelegate,SDPhotoBrowserDelegate>

@property(nonatomic,strong)YHArticlesCellItems *itemModel;
@property(nonatomic,strong)UIImageView* iconImgView;

-(void)setItemModel:(YHArticlesCellItems *)itemModel;

@end
