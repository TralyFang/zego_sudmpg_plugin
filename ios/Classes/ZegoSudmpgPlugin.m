#import "ZegoSudmpgPlugin.h"
#import "ZegoSubmpgFactory.h"

@implementation ZegoSudmpgPlugin

static NSObject<FlutterPluginRegistrar>*_registrar;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"zego_sudmpg_plugin"
            binaryMessenger:[registrar messenger]];
  ZegoSudmpgPlugin* instance = [[ZegoSudmpgPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    
    
    [registrar registerViewFactory:[[ZegoSubmpgFactory alloc] initWithMessenger:registrar.messenger] withId:@"zego_sudmpg_plugin/gameView"];
    
    _registrar = registrar;
}

+ (NSObject<FlutterPluginRegistrar>* _Nullable)getRegistrar {
    return _registrar;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
