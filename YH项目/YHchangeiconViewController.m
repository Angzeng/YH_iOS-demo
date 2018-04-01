//
//  YHchangeiconViewController.m
//  YH项目
//
//  Created by norton on 16/7/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YHchangeiconViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GRZXmainController.h"
#import "YHLoginViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworking.h"

@interface YHchangeiconViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    //下拉菜单
    UIActionSheet *myActionSheet;
    //图片2进制路径
    NSString* filePath;
}
@property (strong, nonatomic)  UIImageView *headImage;  //图片显示区域
@property (strong, nonatomic)  UIImageView *YHuicon;
@property (nonatomic, strong) NSString *iconavater;
@property (strong, nonatomic)  UIAlertView *textalert;
@property (nonatomic,readwrite) BOOL isSubmitted;

@end

@implementation YHchangeiconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _screenWidth = [UIScreen mainScreen].bounds.size.width;//获取屏幕尺寸
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    //self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor grayColor];
    _isSubmitted = NO;
    self.navigationItem.title = @"头 像";
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0.5*_screenWidth-50,_screenWidth+10, 100, 30)];
    rightButton.backgroundColor = [UIColor whiteColor];
    [rightButton setImage:[UIImage imageNamed:@"passagecenter_camare"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:rightButton];
    
    
    //
    NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/User/user";
    NSDictionary *parameters = @{@"uid":YHuid};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置回复内容信息
    [manager.requestSerializer setValue:YHjwt forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:urlStr
       parameters:parameters//请求参数
          success:^(AFHTTPRequestOperation * operation, id responseObject){
              NSString *html = operation.responseString;
              NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
              id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
              
              _iconavater = dict[@"data"][0][@"avatar"];
              NSLog(@"%@",_iconavater);
              UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,_screenWidth,_screenWidth)];
              [iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",_iconavater]] placeholderImage:[UIImage imageNamed:@"imfomation_icon_default"]];
              
              
              
              UIImageView *YHuicon = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,_screenWidth,_screenWidth)];
              //    [YHuicon setImage:[UIImage imageNamed:@"user_sculpture_A"]];
              YHuicon.backgroundColor = [UIColor blackColor];
              [self.view addSubview:YHuicon];
              [self.view addSubview:iconView];
              
          }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
              
          }];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)openMenu//打开 菜单 选择获取图片的方式
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    //在这里呼出下方菜单按钮项
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    
    [myActionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == myActionSheet.cancelButtonIndex)
    {
        // NSLog(@"取消");
    }
    
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
            
        case 1:  //打开本地相册
            [self LocalPhoto];
            
            break;
    }
}

-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *pickerCammer = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            pickerCammer.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerCammer.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerCammer.sourceType];
            pickerCammer.delegate=self;
            pickerCammer.allowsEditing = YES;
            
        }
        [self presentModalViewController:pickerCammer animated:YES];
        
    }else
    {
         NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentModalViewController:picker animated:YES];
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
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        UIImageView *smallimage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,_screenWidth,_screenWidth)];
        
        smallimage.image = image;
        //加在视图中
        [self.view addSubview:smallimage];
        NSString * urlStr = @"http://zhujinchi.com/index.php/Mobile/AvatarUpload/avatarUpload";
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //设置回复内容信息
        [manager.requestSerializer setValue:YHjwt forHTTPHeaderField:@"Authorization"];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        NSDictionary *parameters = @{@"uid":YHuid};
        [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
             // 上传的参数名
             NSString *mimeType;
             if ([[[fileName componentsSeparatedByString:@"."] objectAtIndex:1] isEqualToString:@"png"]) {
                 mimeType = @"image/png";
             }else{
                 mimeType = @"image/jpeg";
             }
             [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:mimeType];
         }
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSString *html = operation.responseString;
             NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
             id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
             NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
             if ([code isEqualToString:@"200"]) {
                 _isSubmitted = YES;
                 [self presentAlert:@"图片上传成功"];
             }else{
                 NSLog(@"%@",dict);
                 [self presentAlert:@"图片上传失败"];
             }
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"发生错误！%@",error);
             [self presentAlert:@"网络错误"];
         }];
    }
    
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


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)sendInfo
{
    // NSLog(@"图片的路径是：%@", filePath);
    
    
    
    // NSLog(@"您输入框中的内容是：%@", _textView.text);
}


//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{  //点击空白区域 键盘消失
//    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
