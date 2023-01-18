#import "CachePlugin.h"
#if __has_include(<cache/cache-Swift.h>)
#import <cache/cache-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "cache-Swift.h"
#endif

@implementation CachePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCachePlugin registerWithRegistrar:registrar];
}
@end
