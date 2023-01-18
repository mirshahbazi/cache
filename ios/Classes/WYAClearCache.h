//
//  WYAClearCache.h
//  CocoaLumberjack
//
//
//
#import <Foundation/Foundation.h>
// Use the automatic calculation unit method, discarding the type type method
// typedef NS_ENUM(NSInteger, WYAFileSizeUnit) {
//    WYAFileSizeUnitMB = 0,
//    WYAFileSizeUnitKB = 1,
//    WYAFileSizeUnitGB = 2
//};
NS_ASSUME_NONNULL_BEGIN

@interface WYAClearCache : NSObject

///**
// Get the system cache caches file size
//
// @param folderSize block form transfer size
// */
//+ (void)wya_defaultCachesFolderSizeBlock:(void (^)(NSString * folderSize))folderSize;
//
///**
// Get system caches file size unit B
//
// @param folderSize folderSize block format transfer size, the unit is B
// */
//+ (void)wya_defaultCachesFolderSizeValueBlock:(void (^)(NSString * folderSize))folderSize;
//
///**
// Clean up the caches path cache
//
// @param clearStatus YES or NO
// */
//+ (void)wya_clearCachesClearStatusBlock:(void (^)(BOOL status))clearStatus;
//
///**
// Get cache file size
//
// @param folderSize block form transfer size
// */
//+ (void)wya_cacheFileSizeAtPath:(NSString *)filePath
// FolderSizeBlock:(void (^)(NSString * folderSize))folderSize;

/**
  Get cache file size unit B

  @param folderSize block form transfer size, the unit is B
  */
+ (void)wya_cacheFileSizeAtPath:(NSString *)filePath
           FolderSizeValueBlock:(void (^)(NSString * _Nonnull))folderSize;

/**
  Clean up custom cache content

  @param filePath path
  @param clearStatus YES or NO
  */
+ (void)wya_clearFileAtPath:(NSString *)filePath
           ClearStatusBlock:(void (^)(BOOL status))clearStatus;

///**
// Get available space/total system space
// For example: available space 3.97G / total space 59.59G
//
// @return string
// */
//+ (NSString *)wya_getDivceSize;

/**
  get free space

  @param folderSize returns the available size
  */
+ (void)wya_getDivceAvailableSizeBlock:(void (^)(NSString * folderSize))folderSize;

/**
  Get the total storage space of Divce
  */
+ (NSString *)wya_getDivceTotalSize;

///**
// Get the total space unit of Divce in KB and return it as a string
//
// @return returns the unprocessed raw data of the total space unit KB
// */
//+ (NSString *)wya_getDivceTotalSizeValue;

///**
// Get the available space unit KB
//
// @param folderSize Unprocessed raw data of available space in KB
// */
//+ (void)wya_getDivceAvailableSizeValueBlock:(void (^)(NSString * folderSize))folderSize;
@end

NS_ASSUME_NONNULL_END
