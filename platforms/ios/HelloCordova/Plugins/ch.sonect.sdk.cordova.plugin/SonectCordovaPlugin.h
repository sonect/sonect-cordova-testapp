#import <Cordova/CDV.h>

@interface SonectCordovaPlugin : CDVPlugin

- (void)init:(CDVInvokedUrlCommand*)command;
- (void)present:(CDVInvokedUrlCommand*)command;
- (void)processTransaction:(CDVInvokedUrlCommand*)command;
- (void)presentTransaction:(CDVInvokedUrlCommand*)command;
- (void)updateBalance:(CDVInvokedUrlCommand*)command;
- (void)hideSdk:(CDVInvokedUrlCommand *)command;

@end
