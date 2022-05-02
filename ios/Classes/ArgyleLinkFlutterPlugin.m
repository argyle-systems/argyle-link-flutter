#import "ArgyleLinkFlutterPlugin.h"
#if __has_include(<argyle_link_flutter/argyle_link_flutter-Swift.h>)
#import <argyle_link_flutter/argyle_link_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "argyle_link_flutter-Swift.h"
#endif

@implementation ArgyleLinkFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftArgyleLinkFlutterPlugin registerWithRegistrar:registrar];
}
@end
