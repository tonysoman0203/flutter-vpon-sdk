#import "VponSdkPlugin.h"
#if __has_include(<vpon_sdk/vpon_sdk-Swift.h>)
#import <vpon_sdk/vpon_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "vpon_sdk-Swift.h"
#endif

@implementation VponSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVponSdkPlugin registerWithRegistrar:registrar];
}
@end
