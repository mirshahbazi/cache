//
//  WYAClearCache.m
//  CocoaLumberjack
//
//

#import "WYAClearCache.h"

#include <sys/mount.h>
#include <sys/param.h>

@implementation WYAClearCache
+ (void)wya_defaultCachesFolderSizeBlock:(void (^)(NSString * folderSize))folderSize
{
    NSString * cachPath = [WYAClearCache wya_libCachePath];
    [self folderSizeAtPath:cachPath FolderSizeBlock:folderSize];
}

+ (void)wya_defaultCachesFolderSizeValueBlock:(void (^)(NSString * _Nonnull))folderSize
{
    NSString * cachPath = [WYAClearCache wya_libCachePath];
    [self folderSizeAtPath:cachPath FolderSizeValueBlock:folderSize];
}

+ (void)wya_cacheFileSizeAtPath:(NSString *)filePath FolderSizeValueBlock:(void (^)(NSString * _Nonnull))folderSize
{
    [self folderSizeAtPath:filePath FolderSizeValueBlock:folderSize];
}

+ (void)wya_cacheFileSizeAtPath:(NSString *)filePath
                FolderSizeBlock:(void (^)(NSString * folderSize))folderSize
{
    [self folderSizeAtPath:filePath FolderSizeBlock:folderSize];
}

+ (void)wya_clearCachesClearStatusBlock:(void (^)(BOOL status))clearStatus
{
    NSString * cachPath = [WYAClearCache wya_libCachePath];
    [self clearFileAtPath:cachPath ClearStatusBlock:clearStatus];
}

+ (void)wya_clearFileAtPath:(NSString *)filePath
           ClearStatusBlock:(void (^)(BOOL status))clearStatus
{
    [self clearFileAtPath:filePath ClearStatusBlock:clearStatus];
}

+ (void)wya_getDivceAvailableSizeBlock:(void (^)(NSString * folderSize))folderSize
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSDictionary * attributes =
    [fileManager attributesOfFileSystemForPath:NSHomeDirectory()
                                         error:nil];
    double folder = [attributes[NSFileSystemFreeSize] doubleValue];

    folderSize([self automaticUnitWith:folder]);
}

+ (void)wya_getDivceAvailableSizeValueBlock:(void (^)(NSString * folderSize))folderSize
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSDictionary * attributes =
    [fileManager attributesOfFileSystemForPath:NSHomeDirectory()
                                         error:nil];
    double folder          = [attributes[NSFileSystemFreeSize] doubleValue];
    NSString * folderValue = [NSString stringWithFormat:@"%f", folder];
    folderSize(folderValue);
}

#pragma mark ======= private methods
+ (void)clearFileAtPath:(NSString *)folderPath ClearStatusBlock:(void (^)(BOOL status))clearStatus
{
    NSFileManager * manage = [NSFileManager defaultManager];

    if (![manage fileExistsAtPath:folderPath]) {
        clearStatus(NO);
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ //address
        NSArray * files = [[NSFileManager defaultManager] subpathsAtPath:folderPath];

        for (NSString * p in files) {
            NSError * error = nil;
            NSString * path = [folderPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            clearStatus(YES);
        });
    });
}

+ (void)folderSizeAtPath:(NSString *)folderPath
         FolderSizeBlock:(void (^)(NSString * fileSize))fileSize
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        fileSize(0);
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ //地址
        NSEnumerator * childFilesEnumerator =
        [[manager subpathsAtPath:folderPath] objectEnumerator];
        NSString * fileName;
        long long folderSize = 0;
        while ((fileName = [childFilesEnumerator nextObject]) != nil) {
            NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //Callback or notify the main thread to refresh,
            fileSize([self automaticUnitWith:folderSize]);
        });
    });
}

+ (void)folderSizeAtPath:(NSString *)folderPath
    FolderSizeValueBlock:(void (^)(NSString * fileSize))fileSize
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        fileSize(0);
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ //address
        NSEnumerator * childFilesEnumerator =
        [[manager subpathsAtPath:folderPath] objectEnumerator];
        NSString * fileName;
        long long folderSize = 0;
        while ((fileName = [childFilesEnumerator nextObject]) != nil) {
            NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //Callback or notify the main thread to refresh,
            fileSize([NSString stringWithFormat:@"%f", folderSize]);
        });
    });
}

+ (long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+ (NSString *)wya_getDivceSize
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSDictionary * attributes =
    [fileManager attributesOfFileSystemForPath:NSHomeDirectory()
                                         error:nil];

    NSLog(@"capacity%.2fG", [attributes[NSFileSystemSize] doubleValue] / (powf(1024, 3)));
    NSLog(@"available%.2fG", [attributes[NSFileSystemFreeSize] doubleValue] / powf(1024, 3));
    NSString * sizeStr =
    [NSString stringWithFormat:@"Available space%0.2fG / total space%0.2fG",
                               [attributes[NSFileSystemFreeSize] doubleValue] / powf(1024, 3),
                               [attributes[NSFileSystemSize] doubleValue] / (powf(1024, 3))];
    return sizeStr;
}

+ (NSString *)wya_getDivceTotalSize
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSDictionary * attributes =
    [fileManager attributesOfFileSystemForPath:NSHomeDirectory()
                                         error:nil];

    NSLog(@"total capacity%.2fG", [attributes[NSFileSystemSize] doubleValue] / (powf(1024, 3)));

    NSString * sizeStr =
    [NSString stringWithFormat:@"%0.2fG", [attributes[NSFileSystemSize] doubleValue] / (powf(1024, 3))];
    return sizeStr;
}

+ (NSString *)wya_getDivceTotalSizeValue
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSDictionary * attributes =
    [fileManager attributesOfFileSystemForPath:NSHomeDirectory()
                                         error:nil];

    NSLog(@"total capacity%f", [attributes[NSFileSystemSize] doubleValue]);

    NSString * sizeValueStr =
    [NSString stringWithFormat:@"%f", [attributes[NSFileSystemSize] doubleValue]];
    return sizeValueStr;
}

// Get cache accurate to MB
+ (NSString *)automaticCacheUnitWith:(double)folder
{
    if (folder / (1000.0 * 1000.0 * 1000.0) < 1) {
        return [NSString stringWithFormat:@"%.2fMB", folder / (1000.0 * 1000.0)];
    } else {
        return [NSString stringWithFormat:@"%.2fGB", folder / (1000.0 * 1000.0 * 1000.0)];
    }
}

// Get Units Automatically
+ (NSString *)automaticUnitWith:(double)folder
{
    if (folder / 1000.0 < 1) {
        return [NSString stringWithFormat:@"%.2fB", folder];
    }
    if (folder / (1000.0 * 1000.0) < 1) {
        return [NSString stringWithFormat:@"%.2fKB", folder / 1000.0];
    }
    if (folder / (1000.0 * 1000.0 * 1000.0) < 1) {
        return [NSString stringWithFormat:@"%.2fMB", folder / (1000.0 * 1000.0)];
    } else {
        return [NSString stringWithFormat:@"%.2fGB", folder / (1000.0 * 1000.0 * 1000.0)];
    }
}

+ (NSString *)wya_libCachePath
{
    NSArray * paths =
    NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}

@end
