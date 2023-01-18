

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>


typedef void (^SaveMediaBlock)(BOOL isSuccess, NSString * result, NSString * imagePath, NSString * videoPath);

@interface AssetCacheTool : NSObject
/// Whether to save to a custom album, the default is bundle_name
@property (nonatomic, assign) BOOL saveAblum;
/// Custom album name
@property (nonatomic, copy) NSString * albumName;
/// Callback when saving pictures or videos
@property (nonatomic, copy) SaveMediaBlock saveMediaBlock;

/**
  Save pictures or local videos to the album, if saveAlbum is YES, and albumName has no value, save to the system album

  @param image image
  @param videoUrl local video url
  */
- (void)savePhtots:(UIImage * _Nullable)image videoUrl:(NSURL * _Nullable)videoUrl callBack:(SaveMediaBlock)callback;

@end
