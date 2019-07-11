#import "SonectCordovaPlugin.h"
#import <Cordova/CDV.h>
#import <Sonect/Sonect.h>

@interface SNCConfiguration (Protected)

- (instancetype)initWithConfigurationType:(NSString *)configurationType
                        alpha2CountryCode:(NSString *)alpha2CountryCode
                                 currency:(NSString *)currency
                      allowedCountryCodes:(NSArray <NSNumber *> *)allowedCountryCodes;
@end

@interface PaymentMethod: NSObject <SNCPaymentMethod>
@property (nonatomic, weak) id <CDVCommandDelegate> commandDelegate;
@end

@implementation PaymentMethod

- (NSString *)detailDescription {
    return @"Neon";
}

- (UIImage *)image {
    return nil;
}

- (NSString *)name {
    return @"Neon";
}

- (NSString *)shortDescription {
    return @"Neon";
}

- (NSString *)uniqueIdentifier {
    return @"Neon";
}

- (void)canPayAmount:(nonnull SNCTransactionAmount *)amount withHandler:(nonnull SNCPaymentMethodAvailabilityHandler)paymentAvailabilityHandler {
    [self.commandDelegate evalJs:@"sonect.checkBalance()"];

    paymentAvailabilityHandler(YES, nil);
}

- (void)payAmount:(nonnull SNCTransactionAmount *)amount withHandler:(nonnull SNCPaymentMethodHandler)handler {
    NSDictionary *parameters = @{
                                 @"value": amount.value.stringValue,
                                 @"currency": amount.currency
                                 };

    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters
                                                   options:0
                                                     error:nil];

    NSString *jsonAmount = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self.commandDelegate evalJs:[NSString stringWithFormat:@"sonect.pay('%@')", jsonAmount]];
}

@end

@interface SonectCordovaPlugin () <SNCSonectPaymentDataSource>

@end

@implementation SonectCordovaPlugin

- (void)present:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = nil;
    NSString *sdkTokenValue = [command.arguments objectAtIndex:0];
    NSString *userIdValue = [command.arguments objectAtIndex:1];
    NSString *signatureValue = [command.arguments objectAtIndex:2];

    if (sdkTokenValue == nil || sdkTokenValue.length == 0 ||
        userIdValue == nil || userIdValue.length == 0 ||
        signatureValue == nil || signatureValue.length == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    else {
        SNCCredentials *credentials = [[SNCCredentials alloc] initWithSdkToken:sdkTokenValue
                                                                        userId:userIdValue
                                                                     signature:signatureValue];

        SNCConfiguration *configuration = [[SNCConfiguration alloc] initWithConfigurationType:@"DEV"
                                                                            alpha2CountryCode:@"CH"
                                                                                     currency:@"CHF"
                                                                          allowedCountryCodes:@[@41]];

        [SNCSonect presentWithCredentials:credentials
                            configuration:configuration
                 presentingViewController:self.viewController];

        SNCSonect.paymentDataSource = self;
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)processTransaction:(CDVInvokedUrlCommand*)command {
    NSString *paymentReference = [command.arguments objectAtIndex:0];
    NSLog(@"%@", paymentReference);
}

- (void)updateBalance:(CDVInvokedUrlCommand*)command {
    NSString *balance = [command.arguments objectAtIndex:0];
    NSLog(@"%@", balance);
}

- (void)closeSonect {
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sonect:(SNCSonect *)sonect loadAvailablePaymentMethodsForContext:(SNCPaymentContext)context handler:(SNCPaymentMethodsHandler)handler {
    PaymentMethod *paymentMethod = [PaymentMethod new];
    paymentMethod.commandDelegate = self.commandDelegate;
    handler(@[paymentMethod], nil);
}

@end
