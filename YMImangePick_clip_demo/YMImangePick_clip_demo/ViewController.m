//
//  ViewController.m
//  YMImangePick_clip_demo
//
//  Created by 刘彦铭 on 2017/5/25.
//  Copyright © 2017年 刘彦铭. All rights reserved.
//

#import "ViewController.h"
#import "TOCropViewController-Bridging-Header.h"


@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate,TOCropViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}




- (IBAction)add:(id)sender {
    
    [self openAlbum];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)openCamera
{
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

- (void)openAlbum
{
    // 如果想自己写一个图片选择控制器，得利用AssetsLibrary.framework，利用这个框架可以获得手机上的所有相册图片
    // UIImagePickerControllerSourceTypePhotoLibrary > UIImagePickerControllerSourceTypeSavedPhotosAlbum
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)type
{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
/**
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // info中就包含了选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
    cropController.delegate = self;
    //截图的展示样式
    cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetCustom;
    //隐藏比例选择按钮
    cropController.aspectRatioPickerButtonHidden = NO;
    cropController.aspectRatioLockEnabled = NO;
    //重置后缩小到当前设置的长宽比
    cropController.resetAspectRatioEnabled = NO;
    //是否可以手动拖动
    cropController.cropView.cropBoxResizeEnabled = YES;
    
    [self presentViewController:cropController animated:NO completion:nil];
    
    cropController.navigationController.navigationItem.rightBarButtonItem = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
}



# pragma mark -TOCropViewControllerDelegate 图片裁剪

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle{
    
    UIImageWriteToSavedPhotosAlbum(image, self, nil, NULL);
    [self dismissViewControllerAnimated:NO completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.imgView.image = image;
}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    
}

@end
