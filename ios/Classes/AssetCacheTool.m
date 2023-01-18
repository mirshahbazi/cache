#import "AssetCacheTool.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@implementation AssetCacheTool
#pragma mark - LifeCircle
- (instancetype)init
{
    self = [super init];
    if (self) {

        NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app name
        NSString * app_Name = [infoDictionary objectForKey:@"CFBundleName"];
        self.albumName      = app_Name;
    }
    return self;
}

/**
 * 保存图片到相册
 */
- (void)savePhtots:(UIImage *)image videoUrl:(NSURL *)videoUrl callBack:(SaveMediaBlock)callback
{
    self.saveMediaBlock = callback;
    // 获取当前的授权状态
    PHAuthorizationStatus lastStatus = [PHPhotoLibrary authorizationStatus];

    // 请求授权
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{

            if (status == PHAuthorizationStatusDenied) {
                if (lastStatus == PHAuthorizationStatusNotDetermined) {
                    //说明，用户之前没有做决定，在弹出授权框中，选择了拒绝
                    callback(NO, @"授权被拒", nil, nil);
                    return;
                }
                // 说明，之前用户选择拒绝过，现在又点击保存按钮，说明想要使用该功能，需要提示用户打开授权
                callback(NO, @"未开启权限", nil, nil);

            } else if (status == PHAuthorizationStatusAuthorized) {
                //保存图片---调用上面封装的方法
                [self saveImageToCustomAblumWithImage:image videoUrl:videoUrl];
            } else if (status == PHAuthorizationStatusRestricted) {
                callback(NO, @"不允许访问", nil, nil);
            }
        });
    }];
}

- (void)saveImageToCustomAblumWithImage:(UIImage *)image videoUrl:(NSURL *)videoUrl
{
    PHFetchResult<PHAsset *> * assets = [self synchronousSaveImageWithPhotosWithImage:image videoUrl:videoUrl];
    if (assets == nil) {
        self.saveMediaBlock(NO, @"保存失败1", nil, nil);
        return;
    }
    if (self.saveAblum == true) {
        // 保存在自定义相册（如果没有则创建）--调用刚才的方法
        PHAssetCollection * assetCollection = [self getAssetCollectionWithAppNameAndCreateCollection];
        if (assetCollection == nil) {
            self.saveMediaBlock(NO, @"保存失败2", nil, nil);
            return;
        }

        // 将刚才保存到相机胶卷的图片添加到自定义相册中 --- 保存带自定义相册--属于增的操作，需要在PHPhotoLibrary的block中进行
        NSError * error = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            // --告诉系统，要操作哪个相册
            PHAssetCollectionChangeRequest * collectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            // --添加图片到自定义相册--追加--就不能成为封面了
            //        [collectionChangeRequest addAssets:assets];
            // --插入图片到自定义相册--插入--可以成为封面
            [collectionChangeRequest insertAssets:assets atIndexes:[NSIndexSet indexSetWithIndex:0]];
        } error:&error];

        if (error) {
            //失败
            self.saveMediaBlock(NO, [error localizedDescription], nil, nil);
            return;
        }
    }


    PHAsset * asset = [assets firstObject];
    if (asset.mediaType == PHAssetMediaTypeImage) {
        PHImageRequestOptions * opi = [[PHImageRequestOptions alloc] init];
        opi.synchronous             = YES; //默认no，异步加载
        opi.resizeMode              = PHImageRequestOptionsResizeModeFast;
        [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                          options:opi
                                                    resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            NSURL * path = [info objectForKey:@"PHImageFileURLKey"];
            self.saveMediaBlock(YES, @"保存成功", path.absoluteString, nil);
                                                    }];
    } else if (asset.mediaType == PHAssetMediaTypeVideo) {
        PHVideoRequestOptions * options = [[PHVideoRequestOptions alloc] init];
        options.version                 = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode            = PHVideoRequestOptionsDeliveryModeAutomatic;

        PHImageManager * manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:asset
                                options:options
                          resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                              AVURLAsset * urlAsset = (AVURLAsset *)asset;

                              NSURL * url     = urlAsset.URL;
                              NSString * path = [url absoluteString];
                              self.saveMediaBlock(YES, @"保存成功", nil, path);
                          }];
    }
}

- (PHFetchResult<PHAsset *> *)synchronousSaveImageWithPhotosWithImage:(UIImage *)image videoUrl:(NSURL *)videoUrl
{
    __block NSString * createdAssetId = nil;

    // 添加图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        if (image) {
            createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
            return;
        }
        if (videoUrl) {
            createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoUrl].placeholderForCreatedAsset.localIdentifier;
            return;
        }

    } error:nil];

    if (createdAssetId == nil) return nil;
    // 在保存完毕后取出图片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[ createdAssetId ] options:nil];
}

- (PHAssetCollection *)getAssetCollectionWithAppNameAndCreateCollection
{
    // 获得所有的自定义相册
    PHFetchResult<PHAssetCollection *> * collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection * collection in collections) {
        if ([collection.localizedTitle isEqualToString:self.albumName]) {
            return collection;
        }
    }

    NSError * error = nil;
    // 代码执行到这里，说明还没有自定义相册
    __block NSString * createdCollectionId = nil;

    // 创建一个新的相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:self.albumName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];

    if (error) {
        return nil;
    } else {
        // 创建完毕后再取出相册
        return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[ createdCollectionId ] options:nil].firstObject;
    }
}

@end
