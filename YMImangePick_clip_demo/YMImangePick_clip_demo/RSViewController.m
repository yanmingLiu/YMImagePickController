//
//  RSViewController.m
//  YMImangePick_clip_demo
//
//  Created by 刘彦铭 on 2017/5/25.
//  Copyright © 2017年 刘彦铭. All rights reserved.
//

#import "RSViewController.h"
#import "TZImagePickerController.h"

#import "RSKImageCropper.h"

@interface RSViewController ()<RSKImageCropViewControllerDelegate,TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end

@implementation RSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

/**
 单张
 */
- (void)chooseOneImage {
    TZImagePickerController *imgPick = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    
    imgPick.sortAscendingByModificationDate = NO;
    
    imgPick.showSelectBtn = NO;
//    imgPick.allowCrop = YES;
    
    // 正方形
    //    imgPick.cropRect = CGRectMake((self.view.frame.size.width-300)/2, (self.view.frame.size.height-300)/2, 300, 300);
    
    // 圆形
//    imgPick.needCircleCrop = YES;
//    imgPick.circleCropRadius = 150;
    
    
    [imgPick setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto){
        
        NSLog(@"%@--%@---%d", photos, assets, isSelectOriginalPhoto);
        UIImage *img = photos[0];
        
        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:img cropMode:RSKImageCropModeCustom];//传入图片与裁剪框的类型
        
        //RSKImageCropModeCustom-自定义
        
        //RSKImageCropModeCircle-圆形
        
        //RSKImageCropModeSquare-矩形
        
        imageCropVC.delegate = self;
        
        imageCropVC.dataSource=self;
        
        [self.navigationController pushViewController:imageCropVC animated:YES];
        
    }];
    [self presentViewController:imgPick animated:YES completion:nil];
}

- (IBAction)add:(id)sender {
    
    [self chooseOneImage];
}

//如果cropMode为RSKImageCropModeCustom自定义类型，则需要加入RSKImageCropViewControllerDataSource进行自定义裁剪框

- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
{
    
    //返回图片的位置
    
    return CGRectMake(0, (self.view.frame.size.width-100)/2, self.view.frame.size.width, 100);
}

- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller {
    
    //返回裁剪框的位置
    
    UIBezierPath *path=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, (self.view.frame.size.width-100)/2, self.view.frame.size.width, 100) cornerRadius:0];
    
    return path;
    
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {
    
    self.imgView.image = croppedImage;
}


@end
