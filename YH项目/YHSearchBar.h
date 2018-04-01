//
//  SearchBar.h
//  JH项目
//
//  Created by Zero on 16/1/28.
//  Copyright (c) 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YHSearchBar;

@protocol YHSearchBarTouchHandler <NSObject>

-(void) buttonTapWith:(NSString *) string;
-(void) textfieldBeginEditing;
-(void) textfieldEndEditing;

@end

@interface YHSearchBar : UIView<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *searchTextField;
@property(nonatomic,strong)UIButton *searchButton;
@property(nonatomic,weak)id<YHSearchBarTouchHandler> searchBarTouchHandlerDelegate;

-(id)initWithFrame:(CGRect)frame WithType:(BOOL)buttonHidden;

@end
