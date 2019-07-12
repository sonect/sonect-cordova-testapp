#import "SonectCordovaPlugin.h"
#import <Cordova/CDV.h>
#import <Sonect/Sonect.h>

@interface SNCConfiguration (Protected)

- (instancetype)initWithConfigurationType:(NSString *)configurationType
                        alpha2CountryCode:(NSString *)alpha2CountryCode
                                 currency:(NSString *)currency
                      allowedCountryCodes:(NSArray <NSNumber *> *)allowedCountryCodes;
@end

@interface TransactionMetadata: NSObject <SNCTransactionMetadata>
@property (nonatomic, readonly) SNCTransactionAmount *amount;

- (instancetype)initWithAmount:(SNCTransactionAmount *)amount;

@end

@implementation TransactionMetadata

- (instancetype)initWithAmount:(SNCTransactionAmount *)amount {
    self = [super init];
    if (self) {
        _amount = amount;
    }
    return self;
}

- (NSDictionary<NSString *,NSString *> *)serialized {
    return @{
             SNCTransactionMetadataKeyAmount: self.amount.value.stringValue,
             SNCTransactionMetadataKeyCurrency: self.amount.currency,
             SNCTransactionMetadataKeyPaymentMethod : @"DIRECT_DEBIT",
             SNCTransactionMetadataKeyPaymentMethodId : @"neon",
             SNCTransactionMetadataKeyType : @"atm",
             SNCTransactionMetadataKeyOpen : @"true"
             };
}

@end

@interface PaymentMethod: NSObject <SNCPaymentMethod>
@property (nonatomic, weak) id <CDVCommandDelegate> commandDelegate;

@property (nonatomic, copy) SNCPaymentMethodAvailabilityHandler availabilityHandler;
@property (nonatomic, copy) SNCPaymentMethodHandler paymentHandler;

@property (nonatomic) SNCTransactionAmount *requestedAmount;

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
    self.availabilityHandler = paymentAvailabilityHandler;
    self.requestedAmount = amount;

    [self.commandDelegate evalJs:@"sonect.checkBalance()"];
}

- (void)payAmount:(nonnull SNCTransactionAmount *)amount withHandler:(nonnull SNCPaymentMethodHandler)handler {
    self.paymentHandler = handler;

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

- (void)updateWithBalance:(SNCTransactionAmount *)balanceAmount {
    if (!self.requestedAmount || !self.availabilityHandler) {
        return;
    }

    NSError *error = nil;
    NSComparisonResult comparisonResult = [balanceAmount compare:self.requestedAmount
                                                 error:&error];
    if (error) {
        self.availabilityHandler(NO, error);
        return;
    }

    if (comparisonResult == NSOrderedDescending) {
        //TODO: write up a proper error.
        NSError *error = [[NSError alloc] initWithDomain:@"ch.sonect.sdk.cordova.error"
                                                    code:101
                                                userInfo:nil];
        self.availabilityHandler(NO, error);
        return;
    }

    self.availabilityHandler(YES, nil);
}

- (void)updateWithPaymentReference:(NSString *)paymentReference {
    if (!self.requestedAmount || !self.paymentHandler) {
        return;
    }

    TransactionMetadata *metadata = [[TransactionMetadata alloc] initWithAmount:self.requestedAmount];
    self.paymentHandler(metadata, nil, SNCPaymentStatusPending);
}

@end

@interface SonectCordovaPlugin () <SNCSonectPaymentDataSource>
@property (nonatomic) PaymentMethod *currentPaymentMethod;
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

    NSParameterAssert(paymentReference);

    [self.currentPaymentMethod updateWithPaymentReference:paymentReference];
}

- (void)updateBalance:(CDVInvokedUrlCommand*)command {
    NSDictionary *balanceDictionary = [command.arguments objectAtIndex:0];
    NSString *value = balanceDictionary[@"value"];
    NSString *currency = balanceDictionary[@"currency"];

    NSParameterAssert(value);
    NSParameterAssert(currency);

    SNCTransactionAmount *amount = [SNCTransactionAmount transactionAmountWithValue:[NSDecimalNumber decimalNumberWithString:value]
                                                                           currency:currency];
    [self.currentPaymentMethod updateWithBalance:amount];
}

- (void)closeSonect {
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sonect:(SNCSonect *)sonect loadAvailablePaymentMethodsForContext:(SNCPaymentContext)context handler:(SNCPaymentMethodsHandler)handler {
    handler(@[self.currentPaymentMethod], nil);
}

- (PaymentMethod *)currentPaymentMethod {
    if (!_currentPaymentMethod) {
        _currentPaymentMethod = [PaymentMethod new];
        _currentPaymentMethod.commandDelegate = self.commandDelegate;
    }
    return _currentPaymentMethod;
}

@end
