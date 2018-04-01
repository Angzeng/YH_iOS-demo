//
//  YHSegmentedScrollView.m
//  YH项目
//
//  Created by Apple on 16/4/20.
//  Copyright (c) 2016年 Apple. All rights reserved.
//

#import "YHSegmentedScrollView.h"

@interface YHSegmentedScrollView()

@property (nonatomic,strong) NSArray *sectionTitles;
@property (nonatomic,strong) UIView *selectionIndicator;
@property(nonatomic,readwrite) UIEdgeInsets edgeInset;
@property (nonatomic,strong) UIFont *textFont;
@property (nonatomic, readwrite) CGFloat segmentWidth;
@property (nonatomic,strong) NSMutableArray *btnArray;

@end

@implementation YHSegmentedScrollView

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor=[UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
        self.scrollEnabled = YES;
        self.alwaysBounceHorizontal = YES;
        self.showsHorizontalScrollIndicator = NO;
        [self setDefaults];
    }
    return  self;
}

- (void) setDefaults{
    self.sectionTitles = @[@"推荐", @"热门", @"关注",@"财经",@"财讯",@"财观"];
    self.edgeInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.textFont = [UIFont fontWithName:@"STHeitiTC-Light" size:18.0f];
    self.segmentWidth = self.frame.size.width/3;
    self.selectedIndex = 0;
    self.contentSize = CGSizeMake(self.segmentWidth*self.sectionTitles.count, -10);
    _btnArray = [NSMutableArray arrayWithCapacity:self.sectionTitles.count];
    [self.sectionTitles enumerateObjectsUsingBlock:^(id item,NSUInteger idx,BOOL *stop){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.segmentWidth * idx,self.frame.origin.y,self.segmentWidth,self.frame.size.height)];
        [label setText:item];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:_textFont];
        [label setBackgroundColor:[UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1]];
        [label setTag:idx];
        if (idx == _selectedIndex) {
            label.textColor = [UIColor whiteColor];
        } else {
            label.textColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        }
        [self addSubview:label];
        [_btnArray addObject:label];
    }];
    self.selectionIndicator = [UIView new];
    self.selectionIndicator.backgroundColor = [UIColor whiteColor];
    [self updateframeForIndicator];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)]];
}

-(void)updateframeForIndicator{
    NSDictionary *attributes = @{NSFontAttributeName:self.textFont,};
    CGFloat titleWidth = [[self.sectionTitles objectAtIndex:self.selectedIndex] boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size.width;
    CGFloat x = ((self.segmentWidth - titleWidth)/2) + (self.segmentWidth * self.selectedIndex);
    self.selectionIndicator.frame =CGRectMake(x, self.frame.size.height, titleWidth, -self.edgeInset.top);
    [self addSubview:self.selectionIndicator];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.btnArray enumerateObjectsUsingBlock:^(UILabel *button, NSUInteger idx, BOOL *stop) {
        //        [button removeFromSuperview];
        if (idx == self.selectedIndex) {
            button.textColor = [UIColor whiteColor];
            [UIView animateWithDuration:0.2 animations:^{
                button.transform = CGAffineTransformMakeScale(1.2, 1.2);
            }];
        }else{
            button.textColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
            [UIView animateWithDuration:0.2 animations:^{
                button.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }
        [self addSubview:button];
    }];
    [self updateframeForIndicator];
}

- (void) SingleTap:(UIGestureRecognizer *) sender{
    CGPoint point = [sender locationInView:[sender view]];
    NSInteger max = self.btnArray.count;
    if (CGRectContainsPoint(self.bounds,point)){
        NSInteger segment = point.x / self.segmentWidth;
        if (segment == 0) {
            [self setContentOffset:CGPointMake(0, 0) animated:YES];
        }else if (segment == max - 1){
            [self setContentOffset:CGPointMake((segment-2)*_segmentWidth, 0) animated:YES];
        }else{
            [self setContentOffset:CGPointMake((segment-1)*_segmentWidth, 0) animated:YES];
        }
        if (segment != self.selectedIndex) {
            _selectedIndex = segment;
            [self setNeedsLayout];
            [self.segmTouchHandlerDelegate segmentedControlChangedValue:self];
        }
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
