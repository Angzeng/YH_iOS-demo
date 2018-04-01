//
//  SearchBar.m
//  JH项目
//
//  Created by Zero on 16/1/28.
//  Copyright (c) 2016年 Apple. All rights reserved.
//

#import "YHSearchBar.h"

@interface YHSearchBar ()

@property(nonatomic,readwrite)UIEdgeInsets edge;
@property(nonatomic,readwrite)BOOL buttonHidden;

@end

@implementation YHSearchBar

-(id) initWithFrame:(CGRect)frame WithType:(BOOL)buttonHidden{
    self = [super initWithFrame:frame];
    if (self) {
        _edge = UIEdgeInsetsMake(5, 5, 5, 5);
        _buttonHidden = buttonHidden;
        [self setItems];
    }
    return self;
}

-(void)setItems{
    self.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    
    self.searchButton = [[UIButton alloc] init];
    [self.searchButton setTitle:@"取消" forState:UIControlStateNormal];
    self.searchButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.searchButton.backgroundColor = [UIColor clearColor];
    CGSize Size = [_searchButton sizeThatFits:CGSizeMake(MAXFLOAT,self.frame.size.height-2*_edge.top)];
    [self.searchButton setFrame:CGRectMake(self.frame.size.width-_edge.right, _edge.top, -Size.width, Size.height)];
    [self.searchButton addTarget:self action:@selector(buttonTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_searchButton];
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(_edge.left, _edge.top, self.frame.size.width-Size.width - 3*_edge.right, Size.height)];
    UIImageView *searchImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _searchTextField.frame.size.height, _searchTextField.frame.size.height)];
    searchImgView.image = [UIImage imageNamed:@"discover_find"];
    searchImgView.contentMode = UIViewContentModeCenter;
    self.searchTextField.leftView = searchImgView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.layer.cornerRadius = 4.0;
    self.searchTextField.layer.borderWidth = 0.0;
    self.searchTextField.placeholder = @"搜索";
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeyDone;
    [self.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_searchTextField];
    [self setColors:NO];
}

-(void)setColors:(BOOL)isEditing{
    if (_buttonHidden && !isEditing) {
        [self.searchTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.searchTextField.backgroundColor = [UIColor clearColor];
        self.searchTextField.textColor = [UIColor whiteColor];
        if ([self isBlankString:self.searchTextField.text]) {
            [self.searchButton setTitleColor:[UIColor clearColor]forState:UIControlStateNormal];
        }
    }else{
        [self.searchTextField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.searchTextField.backgroundColor = [UIColor whiteColor];
        self.searchTextField.textColor = [UIColor blackColor];
        [self.searchButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    }

}

-(void)buttonTap{
    [self textFieldDidEndEditing:_searchTextField];
    [self.searchBarTouchHandlerDelegate buttonTapWith:_searchTextField.text];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.searchBarTouchHandlerDelegate textfieldBeginEditing];
    [self setColors:YES];
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    if ( [self isBlankString:theTextField.text] && [self.searchButton.titleLabel.text isEqual:@"搜索"]) {
        [self.searchButton setTitle:@"取消" forState:UIControlStateNormal];
    }else if ([self.searchButton.titleLabel.text isEqual:@"取消"] && (![self isBlankString:theTextField.text])){
        [self.searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    }else{
        ;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.searchBarTouchHandlerDelegate textfieldEndEditing];
    [self setColors:NO];
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
