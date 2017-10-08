//
//  TZCollectionViewController.m
//  YMImangePick_clip_demo
//
//  Created by 刘彦铭 on 2017/5/25.
//  Copyright © 2017年 刘彦铭. All rights reserved.
//

#import "TZCollectionViewController.h"
#import "TZImagePickerController.h"

#import "MWPhotoBrowser.h"

@interface TZCollectionViewController () <TZImagePickerControllerDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSMutableArray *selectedAssets;

@property (nonatomic, strong) TZImagePickerController *imgPick;

@end

@implementation TZCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    [self setLayout];
    
    self.dataArr = [NSMutableArray array];
    
    
    
}

#pragma mark - TZImagePickerController使用


- (IBAction)do:(id)sender {
    
    [self chooseMoreImage];
}


/**
 单张
 */
- (void)chooseOneImage {
    TZImagePickerController *imgPick = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    
    imgPick.sortAscendingByModificationDate = NO;
    /*
    /// 单选模式,maxImagesCount为1时才生效
    @property (nonatomic, assign) BOOL showSelectBtn;   ///< 在单选模式下，照片列表页中，显示选择按钮,默认为NO
    @property (nonatomic, assign) BOOL allowCrop;       ///< 允许裁剪,默认为YES，showSelectBtn为NO才生效
    @property (nonatomic, assign) CGRect cropRect;      ///< 裁剪框的尺寸
    @property (nonatomic, assign) BOOL needCircleCrop;  ///< 需要圆形裁剪框
    @property (nonatomic, assign) NSInteger circleCropRadius;  ///< 圆形裁剪框半径大小
    @property (nonatomic, copy) void (^cropViewSettingBlock)(UIView *cropView);     ///< 自定义裁剪框的其他属性
     */
    imgPick.showSelectBtn = NO;
    imgPick.allowCrop = YES;
    
    // 正方形
    imgPick.cropRect = CGRectMake(20, self.view.bounds.size.height/2-(self.view.bounds.size.width-40)/2, self.view.bounds.size.width-40, self.view.bounds.size.width-40);
    
    // 圆形
//    imgPick.needCircleCrop = YES;
//    imgPick.circleCropRadius = 150;
    

    [imgPick setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto){
        NSLog(@"%@--%@---%d", photos, assets, isSelectOriginalPhoto);
        
        [self.dataArr addObjectsFromArray:photos];
        
        [self.collectionView reloadData];
    }];
    [self presentViewController:imgPick animated:YES completion:nil];
}

/**
 1.多张
 */
- (void)chooseMoreImage {
    self.imgPick = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    _imgPick.sortAscendingByModificationDate = NO;
    
    _imgPick.selectedAssets = self.selectedAssets;
    /**
     1.使用block回调
     */
    [_imgPick setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto){
        NSLog(@"%@--%@---%d", photos, assets, isSelectOriginalPhoto);

        [self.dataArr removeAllObjects];
        
        [self.dataArr addObjectsFromArray:photos];

        [self.collectionView reloadData];
        
        // 记录选中过的
        self.selectedAssets = [NSMutableArray arrayWithArray:assets];
    }];
    [self presentViewController:_imgPick animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate

/**
 2.使用代理
 */
- (void)imagePickerController:(TZImagePickerController *)imagePickerVc didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
//    [self.dataArr addObjectsFromArray:photos];
//    
//    [self.collectionView reloadData];
    
}



#define  kSectionMargin 10

#pragma mark- UICollectionViewLayout

- (void)setLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //头部大小
    flowLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width/2);
    
    //每行3个Cell
    CGFloat screenWith = self.view.bounds.size.width;
    CGFloat cellWidth = (screenWith - 4 *kSectionMargin)/3 ;
    //定义每个item 的大小
    flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    
    //定义每个item 横向的间距
    flowLayout.minimumLineSpacing = kSectionMargin;
    //定义每个item 纵向的间距
    flowLayout.minimumInteritemSpacing = kSectionMargin;
    //定义每个item 的边距距 //上左下右
//    flowLayout.sectionInset = UIEdgeInsetsMake(kSectionMargin, kSectionMargin, kSectionMargin, kSectionMargin);
    
    self.collectionView.collectionViewLayout = flowLayout;
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
    imgView.image = self.dataArr[indexPath.row];
    [cell.contentView addSubview:imgView];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self initMWPhotoBrowserWithIndexPath:indexPath];
}



#pragma mark - MWPhotoBrowserDelegate

- (void)initMWPhotoBrowserWithIndexPath:(NSIndexPath *)indexPath {
    //创建MWPhotoBrowser ，要使用initWithDelegate方法，要遵循MWPhotoBrowserDelegate协议
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    browser.displayActionButton = NO;//分享按钮,默认是
    browser.displayNavArrows = NO;//左右分页切换,默认否<屏幕下方的左右角标>
    browser.displaySelectionButtons = NO;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = YES;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = YES;//是否全屏,默认是
    browser.enableGrid = NO;//是否允许用网格查看所有图片,默认是
     
    browser.enableSwipeToDismiss = NO;
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    
    //设置当前要显示的图片
    [browser setCurrentPhotoIndex:indexPath.row];
    //push到MWPhotoBrowser
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate

//返回图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    
    return self.dataArr.count;
    
}

//返回图片模型
- (id )photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
     //此处需要注意的是，self.photos  存放的都是MWPhoto 对象
    //创建图片模型
    MWPhoto *photo = [MWPhoto photoWithImage:self.dataArr[index]];
    
    return photo;
    
}


@end
