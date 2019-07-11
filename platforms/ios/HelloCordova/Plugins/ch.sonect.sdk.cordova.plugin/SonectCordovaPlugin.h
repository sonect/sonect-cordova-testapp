#import <Cordova/CDV.h>

@interface SonectCordovaPlugin : CDVPlugin

- (void)present:(CDVInvokedUrlCommand*)command;
- (void)processTransaction:(CDVInvokedUrlCommand*)command;
- (void)updateBalance:(CDVInvokedUrlCommand*)command;

@end
