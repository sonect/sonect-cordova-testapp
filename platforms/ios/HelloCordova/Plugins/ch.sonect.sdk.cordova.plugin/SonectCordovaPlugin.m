#import "SonectCordovaPlugin.h"
#import <Cordova/CDV.h>
#import <Sonect/Sonect.h>

@implementation SonectCordovaPlugin

- (void)echo:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = nil;
    NSString *tokenValue = [command.arguments objectAtIndex:0];

    if (tokenValue == nil || [tokenValue length] == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    else {
        SNCToken *token = [SNCToken tokenWithValue:tokenValue type:nil];
        SNCConfiguration *configuration = [[SNCConfiguration alloc] initWithToken:token
                                                                            theme:nil
                                                                         currency:@"CHF"
                                                              allowedCountryCodes:@[@41]];
        UIViewController *viewController = [SNCSonect makeViewControllerWithConfiguration:configuration
                                                                               dataSource:nil];
        viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                                         target:self
                                                                                                         action:@selector(closeSonect)];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self.viewController presentViewController:navigationController animated:YES completion:nil];


        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                         messageAsString:tokenValue];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)closeSonect {
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
