//
//  ViewController.m
//  test1
//
//  Created by 刘智诚 on 2017/8/7.
//  Copyright © 2017年 刘智诚. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import "PhotoController.h"

@interface ViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *photoArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self genLibrary];
    
}

- (void)genLibrary
{
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        if (status == PHAuthorizationStatusAuthorized) {
            
           // [self fetchPhotos];
            
        }else
        {
            NSLog(@"PHAuthorizationStatusDenied");
        }
        
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.photoArr removeAllObjects];
    [self fetchPhotos];
}

- (void)fetchPhotos
{
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 这边自定义的相册
    for (PHAssetCollection *collection in result) {
        
        [self enumerateAssetsInAssetCollection:collection original:NO];
        
    }
    
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
    
}

/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            [self.photoArr addObject:result];
            
            if (assets.lastObject == asset) {
                
                
                UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
                layout.itemSize = CGSizeMake(self.view.bounds.size.width / 4, self.view.bounds.size.width / 4);
                layout.minimumLineSpacing = 0;
                layout.minimumInteritemSpacing = 0;
                
                self.collectionView.collectionViewLayout = layout;
                
                PhotoController *vc = [[PhotoController alloc]initWithCollectionViewLayout:layout];
                vc.photoArr = self.photoArr;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            NSLog(@"%@", result);
        }];
    }
}

- (NSMutableArray *)photoArr
{
    if (!_photoArr) {
        _photoArr = [NSMutableArray array];
    }
    return _photoArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
