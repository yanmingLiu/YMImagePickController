//
//  RSViewController.m
//  YMImangePick_clip_demo
//
//  Created by 刘彦铭 on 2017/5/25.
//  Copyright © 2017年 刘彦铭. All rights reserved.
//

#import "RSViewController.h"

#import "RSKImageCropper.h"

@interface RSViewController ()<RSKImageCropViewControllerDelegate>

@end

@implementation RSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:[UIImage imageNamed:@""] cropMode:RSKImageCropModeCustom];//传入图片与裁剪框的类型
    
    //RSKImageCropModeCustom-自定义
    
    //RSKImageCropModeCircle-圆形
    
    //RSKImageCropModeSquare-矩形
    
    imageCropVC.delegate = self;
    
    imageCropVC.dataSource=self;
    
    [self.navigationController pushViewController:imageCropVC animated:YES];
    
    
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


@end
