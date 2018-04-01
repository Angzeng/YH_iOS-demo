//
//  WriteTextViewController.m
//  JH项目
//
//  Created by zhujinchi on 15/12/2.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YHWriteTextViewController.h"
#import "YHWriteTitleViewController.h"
#import "YHLoginViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworking.h"

@interface YHWriteTextViewController()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    //下拉菜单
    UIActionSheet *myActionSheet;
    //图片2进制路径
    NSString* filePath;
}

@property (strong, nonatomic)  UILabel *topLabel;//最上面标签 显示字数
@property (strong, nonatomic)  UIButton *leftButton;//返回按钮
@property (strong, nonatomic)  UIButton *rightButton; //插图图片按钮
@property (strong, nonatomic)  UITextView *textView;   //文本输入框
@property (strong, nonatomic)  UIImageView *headImage;  //图片显示区域
@property (strong, nonatomic)  UIAlertView *textalert;
@property (strong, nonatomic)  NSNumber *articletype;
@property (strong, nonatomic)  NSMutableDictionary *dict;


@end

@implementation YHWriteTextViewController

- (void)loadView
{
    [super loadView];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [scrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 128)];
    self.view = scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _articletype = @-1;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;//获取屏幕尺寸
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _isSubmitted = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"正 文";
    self.tabBarController.tabBar.hidden = YES;  //隐藏tabbar
    _dict = [[NSMutableDictionary alloc] init];
    [self setupText];  //以下依次启动控件
    [self setupTopLabel];
    [self setupLeftButton];
    [self setupRightButton];
    [self setupSubmit];
    [self.textView becomeFirstResponder];
    //
    UILabel *lablebackground1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _screenHeight - 40 - 64, _screenWidth,40)];
    lablebackground1.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [self.view addSubview:lablebackground1];
    //
    UILabel *lablebackground2 = [[UILabel alloc]initWithFrame:CGRectMake(10, _screenHeight - 35 - 64,_screenWidth-180,30)];
    lablebackground2.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [lablebackground2 setText:@"请选择上传的文章类型:"];
    lablebackground2.textColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    lablebackground2.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:13];
    [lablebackground2 setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:lablebackground2];
    
    //
    
    NSArray *array = @[@"财经类",@"财讯类",@"财观类"];
    
    UISegmentedControl *segmentedController = [[UISegmentedControl alloc] initWithItems:array];
    segmentedController.tintColor=[UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    [segmentedController setFrame:CGRectMake(_screenWidth-160,_screenHeight - 35 - 64,150, 30)];
    segmentedController.selectedSegmentIndex = -1;
    
    [segmentedController addTarget:self action:@selector(setuparticletype:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segmentedController];
}
//

//

-(void)viewWillDisappear:(BOOL)animated{
    if (_isSubmitted) {
        self.tabBarController.tabBar.hidden = YES;
    }
}

-(void)setuparticletype:(id)sender{
    switch ([sender selectedSegmentIndex]) {
        case 0:{
            _articletype=@3;
        }
            break;
        case 1:{
            _articletype=@4;
        }
            break;
        case 2:{
            _articletype=@5;
        }
            break;
    }
}

-(void)setupText{//文本输入框
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10,60,_screenWidth-20,_screenHeight - 100 - 64)];
    //    _textView.layer.borderColor=[UIColor grayColor].CGColor;  //边框显示
    //    _textView.layer.borderWidth=1.0;
    //    _textView.layer.cornerRadius=5.0;
    _textView.font = [UIFont fontWithName:@"Arial" size:17.0f];
    _textView.textColor = [UIColor blackColor];
    self.textView.delegate = self;
    [self calculateAndDisplayTextViewLengthWithText:self.textView.text];
    [self.view addSubview:_textView];
}
-(void)setupTopLabel{  //最上面标签 显示字数
    _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(70.0f,10.0f,_screenWidth-140,50.0f)];
    _topLabel.font=[UIFont boldSystemFontOfSize:20];
    _topLabel.textAlignment = NSTextAlignmentCenter;
    _topLabel.textColor = [UIColor blackColor];
    _topLabel.text = @"0 / 5000";
    [self.view addSubview:_topLabel];
    
}

-(void)setupLeftButton{ //返回按钮
    _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(10,10, 50, 50)];
    [_leftButton setImage:[UIImage imageNamed:@"passagecenter_deny"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_leftButton];
}
-(void)back{    //返回时调用
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)setupRightButton{  //插入图片按钮
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(_screenWidth-60,10, 50, 50)];
    [_rightButton setImage:[UIImage imageNamed:@"passagecenter_camare"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(LocalPhoto) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_rightButton];
}
- (void)submit{
    if ([_articletype isEqualToNumber: @-1]) {
        _textalert=[[UIAlertView alloc]initWithTitle:@"请选择文章分类" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
        [_textalert show];
    }else{
        //保存数据并上传服务器
        if (_textView.text.length == 0 ) {
            _textalert=[[UIAlertView alloc]initWithTitle:@"请输入内容" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
            [_textalert show];
        }
        if (_textView.text.length > 5000) {
            _textalert=[[UIAlertView alloc]initWithTitle:@"内容字数超标" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
            [_textalert show];
        }
        if (_textView.text.length > 0 && _textView.text.length <= 5000) {
            //
            NSString *html = [self attriToStrWithAttri:_textView.attributedText];
            NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/ArticleUpload/articleUpload";
            NSDictionary *parameters = @{@"uid":YHuid,@"title":YHarticletitle,@"art_content":html,@"class":_articletype};
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            //设置回复内容信息
            [manager.requestSerializer setValue:YHjwt forHTTPHeaderField:@"Authorization"];
            manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
            
            [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
             {
                 // 上传 多张图片
                 for(NSInteger i = 0; i < _dict.count; i++) {
                     
                     NSString *fileName = [[_dict allKeys] objectAtIndex:i];
                     NSData * imageData = [_dict valueForKey:fileName];
                     // 上传的参数名
                     NSString *mimeType;
                     if ([[[fileName componentsSeparatedByString:@"."] objectAtIndex:1] isEqualToString:@"png"]) {
                         mimeType = @"image/png";
                     }else{
                         mimeType = @"image/jpeg";
                     }
                     [formData appendPartWithFileData:imageData name:@"file[]" fileName:fileName mimeType:mimeType];
                 }
             }
                  success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 NSString *html = operation.responseString;
                 NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                 id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];\
                 NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
                 if ([code isEqualToString:@"200"]) {
                     _isSubmitted = YES;
                     [self presentAlert:@"上传文章成功"];
                 }else{
                     [self presentAlert:@"上传文章失败"];
                 }
             }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error){
                      [self presentAlert:@"网络错误"];
                  }];
        }
    }
}

-(void) presentAlert:(NSString*)content{
    //设置alert时间响应
    _textalert = [[UIAlertView alloc]initWithTitle:content message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
    [_textalert show];
}


-(void) performDismiss:(NSTimer *)timer
{
    [_textalert dismissWithClickedButtonIndex:0 animated:NO];
    if (_isSubmitted == YES) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    //    [_registeralert release];
}

-(void)setupSubmit{  //提交按钮
    UIButton * submitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [submitButton setImage:[UIImage imageNamed:@"passagecenter_up"] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchDown];
    //这里添加上传事件响应
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithCustomView:submitButton];
    self.navigationItem.rightBarButtonItem=rightItem;
}


-(void)calculateAndDisplayTextViewLengthWithText:(NSString *)paramText{//计算字数
    NSString *characterOrCharacters = @" / 5000";
    if([paramText length] == 1){
        characterOrCharacters = @" / 5000";
    }
    if ([paramText length]>5000) {
        self.topLabel.textColor=[UIColor redColor];
    }
    else{
        self.topLabel.textColor=[UIColor blackColor];
    }
    self.topLabel.text = [NSString stringWithFormat:@"%lu%@",(unsigned long)[paramText length],characterOrCharacters];
}

//限制输入类型 暂无限制
-(BOOL)textView:(UITextView *)textView shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL result = YES;
    if([textView isEqual:self.textView]){
        NSString *wholeText = [textView.text stringByReplacingCharactersInRange:range withString:string];
        [self calculateAndDisplayTextViewLengthWithText:wholeText];
    }
    return result;
}


-(BOOL)textViewShouldReturn:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

-(void)textViewDidChange:(UITextView*)textView{ //文本改变时调用
    [self calculateAndDisplayTextViewLengthWithText:self.textView.text];
}

- (void)viewWillAppear:(BOOL)animated//监听事件 监听键盘
{
    //注册通知,监听键盘出现
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidShow:)
                                                name:UIKeyboardDidShowNotification
                                              object:nil];
    //注册通知，监听键盘消失事件
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidHidden)
                                                name:UIKeyboardDidHideNotification
                                              object:nil];
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}


//监听事件
- (void)handleKeyboardDidShow:(NSNotification*)paramNotification
{
    //获取键盘高度
    NSValue *keyboardRectAsObject=[[paramNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    [keyboardRectAsObject getValue:&keyboardRect];
    
    self.textView.contentInset=UIEdgeInsetsMake(0, 0,80, 0);
}

- (void)handleKeyboardDidHidden //键盘已经隐藏
{
    self.textView.contentInset=UIEdgeInsetsZero;
}

- (void)viewDidDisappear:(BOOL)animated//键盘已经消失
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
}


//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        if (!image) {
            image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        }
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        NSString *ext = @".png";
        
        for (NSData *d in [_dict allValues]) {
            if ([d isEqualToData:data]) {
                [picker dismissViewControllerAnimated:YES completion:nil];
                [self InsetPhoto:[self ScaledImage:[UIImage imageWithData:data]]];
                return;
            }
        }
        
        if (_dict.count == 0) {
            [_dict setObject:data forKey:[@"Attachment" stringByAppendingString:ext]];
        }else{
            [_dict setObject:data forKey:[NSString stringWithFormat:[@"Attachment_%d" stringByAppendingString:ext],_dict.count]];
        }
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fileName = [self HashNameWith: ext];
        
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:fileName] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,fileName];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        [self InsetPhoto:[self ScaledImage: [UIImage imageWithData:data]]];
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{  //点击空白区域 键盘消失
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)InsetPhoto:(UIImage *) image{
    
    NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    if (textString.length != 0) {
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    }
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
    textAttachment.image = image; //要添加的图片
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
    
    [string insertAttributedString:textAttachmentString atIndex:string.length];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    
    [textString insertAttributedString:string atIndex:_textView.selectedRange.location];//index为用户指定要插入图片的位置
    _textView.attributedText = textString;
    _textView.font = [UIFont fontWithName:@"Arial" size:17.0f];
    _textView.selectedRange = NSMakeRange(_textView.attributedText.length, 0);
    NSRange range;
    range = NSMakeRange (_textView.attributedText.length, 0);
    [_textView scrollRangeToVisible: range];
    
}

-(NSString *)attriToStrWithAttri:(NSAttributedString *)attri{
    NSDictionary *tempDic = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                              NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
    NSData *htmlData = [attri dataFromRange:NSMakeRange(0, attri.length)
                         documentAttributes:tempDic
                                      error:nil];
    NSString *s = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    NSArray *reg = [NSArray arrayWithObjects:@"<img src=\"file:///", @" alt=\"Attachment[\\s\\S]{3,5}g\"", @"<br></p>", @"<p class=\"p[0-9]\"><span class=\"s[0-9]\"></span></p>\n",nil];
    NSArray *rep = [NSArray arrayWithObjects:@"<img src=\"", @"", @"</p>", @"", nil];
    NSError *error = NULL;
    NSRegularExpression *regular;
    NSString *result = s;
    for (int i = 0; i < reg.count; i++){
        regular = [NSRegularExpression regularExpressionWithPattern:[reg objectAtIndex:i] options:NSRegularExpressionCaseInsensitive error:&error];
        result = [regular stringByReplacingMatchesInString:result options:NSMatchingReportProgress range:NSMakeRange(0, result.length) withTemplate:[rep objectAtIndex:i]];
    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<body>[\\s\\S]*</body>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *r = [regex firstMatchInString:result options:0 range:NSMakeRange(0, [result length])];
    if (r) {
        result = [result substringWithRange:r.range];
        result = [result substringWithRange: NSMakeRange(7, result.length - 15)];
    }
    return result;
}


- (UIImage*) ScaledImage:(UIImage *)image
{
    CGSize newSize;
    CGFloat height = image.size.height*((CGFloat)_screenWidth)/image.size.width;
    newSize = CGSizeMake(_screenWidth, height);
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (NSString *) HashNameWith:(NSString*)ext{
    NSString *ori = [NSString stringWithFormat:@"%4x",arc4random()%0x10000];
    NSString *hash = [[self MD5:ori] stringByAppendingString:[NSString stringWithFormat:@"%4x",arc4random()%0x10000]];
    return [@"/" stringByAppendingString:[[self MD5:hash] stringByAppendingString:ext]];
}

- (NSString *)MD5:(NSString *)mdStr
{
    const char *original_str = [mdStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

@end
