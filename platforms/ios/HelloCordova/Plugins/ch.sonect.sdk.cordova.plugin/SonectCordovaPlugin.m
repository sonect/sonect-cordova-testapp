#import "SonectCordovaPlugin.h"
#import <Cordova/CDV.h>
#import <Sonect/Sonect.h>

@interface NSDictionary (JSON)

- (NSString *)snc_jsonString;

@end

@implementation NSDictionary (JSON)

- (NSString *)snc_jsonString {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:0
                                                     error:nil];

    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end

@interface PaymentMethod: NSObject <SNCPaymentMethod>
@property (nonatomic, weak) id <CDVCommandDelegate> commandDelegate;
@property (nonatomic, copy) SNCPaymentMethodAvailabilityHandler availabilityHandler;
@property (nonatomic, copy) SNCPaymentMethodHandler paymentHandler;
@property (nonatomic) SNCTransactionAmount *requestedAmount;

@property (nonatomic, readonly) NSString *uniqueIdentifier;
@property (nonatomic, readonly) NSString *detailDescription;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *shortDescription;

@end

@implementation PaymentMethod

- (NSString *)shortDescription {
    return self.detailDescription;
}


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _uniqueIdentifier = dictionary[@"uniqueIdentifier"];
        _detailDescription = dictionary[@"detailDescription"];
        _image = [UIImage imageNamed:dictionary[@"image"]];
        _name = dictionary[@"name"];
    }
    return self;

}

- (void)canPayAmount:(nonnull SNCTransactionAmount *)amount withHandler:(nonnull SNCPaymentMethodAvailabilityHandler)paymentAvailabilityHandler {
    self.availabilityHandler = paymentAvailabilityHandler;
    self.requestedAmount = amount;

    [self.commandDelegate evalJs:[NSString stringWithFormat:@"sonect.checkBalance('%@')", self.uniqueIdentifier]];
}

- (void)payAmount:(nonnull SNCTransactionAmount *)amount withHandler:(nonnull SNCPaymentMethodHandler)handler {
    self.paymentHandler = handler;

    NSDictionary *parameters = @{
                                 @"uniqueIdentifier": self.uniqueIdentifier,
                                 @"value": amount.value.stringValue,
                                 @"currency": amount.currency
                                 };

    [self.commandDelegate evalJs:[NSString stringWithFormat:@"sonect.pay('%@')", parameters.snc_jsonString]];
}

- (void)updateWithBalance:(SNCTransactionAmount *)balanceAmount {
    if (!self.requestedAmount || !self.availabilityHandler) {
        return;
    }

    NSError *error = nil;
    NSComparisonResult comparisonResult = [self.requestedAmount compare:balanceAmount
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

    SNCBankTransactionMetadata *metadata = [SNCBankTransactionMetadata transactionMetadataWithAmount:self.requestedAmount
                                                                                    paymentReference:paymentReference];
    self.paymentHandler(metadata, nil, SNCPaymentStatusPending);
}

@end

@interface SonectCordovaPlugin () <SNCSonectPaymentDataSource>
@property (nonatomic) NSArray *paymentMethods;
@end

@implementation SonectCordovaPlugin

- (void)present:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = nil;
    NSString *sdkTokenValue = [command.arguments objectAtIndex:0];
    NSString *userIdValue = [command.arguments objectAtIndex:1];
    NSString *signatureValue = [command.arguments objectAtIndex:2];
    NSArray *paymentMethodDictionaries = [command.arguments objectAtIndex:3];

    if (sdkTokenValue == nil || sdkTokenValue.length == 0 ||
        userIdValue == nil || userIdValue.length == 0 ||
        signatureValue == nil || signatureValue.length == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    else {
        SNCCredentials *credentials = [[SNCCredentials alloc] initWithSdkToken:sdkTokenValue
                                                                        userId:userIdValue
                                                                     signature:signatureValue];

        SNCConfiguration *configuration = [SNCConfiguration defaultConfiguration];

        [SNCSonect presentWithCredentials:credentials
                            configuration:configuration
                 presentingViewController:self.viewController];

        SNCSonect.paymentDataSource = self;

        self.paymentMethods = [self makePaymentMethods:paymentMethodDictionaries];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (NSArray *)makePaymentMethods:(NSArray *)paymentMethodDictionaries {
    NSAssert([paymentMethodDictionaries isKindOfClass:NSArray.class], @"Pass an array of payment methods");

    NSMutableArray *paymentMethods = [NSMutableArray new];
    for (NSDictionary *dictionary in paymentMethodDictionaries) {
        PaymentMethod *paymentMethod = [[PaymentMethod alloc] initWithDictionary:dictionary];
        paymentMethod.commandDelegate = self.commandDelegate;
        [paymentMethods addObject:paymentMethod];
    }
    return paymentMethods.copy;
}

- (void)processTransaction:(CDVInvokedUrlCommand*)command {
    NSDictionary *paymentDictionary = [command.arguments objectAtIndex:0];

    NSString *uniqueIdentifier = paymentDictionary[@"uniqueIdentifier"];
    NSString *paymentReference = paymentDictionary[@"paymentReference"];

    NSParameterAssert(uniqueIdentifier);
    NSParameterAssert(paymentReference);

    PaymentMethod *paymentMethod = [self paymentMethodWithUniqueIdentifier:uniqueIdentifier];
    [paymentMethod updateWithPaymentReference:paymentReference];
}

- (void)updateBalance:(CDVInvokedUrlCommand*)command {
    NSDictionary *balanceDictionary = [command.arguments objectAtIndex:0];

    NSString *uniqueIdentifier = balanceDictionary[@"uniqueIdentifier"];
    NSString *value = balanceDictionary[@"value"];
    NSString *currency = balanceDictionary[@"currency"];

    NSParameterAssert(uniqueIdentifier);
    NSParameterAssert(value);
    NSParameterAssert(currency);

    SNCTransactionAmount *amount = [SNCTransactionAmount transactionAmountWithValue:[NSDecimalNumber decimalNumberWithString:value]
                                                                           currency:currency];
    PaymentMethod *paymentMethod = [self paymentMethodWithUniqueIdentifier:uniqueIdentifier];
    [paymentMethod updateWithBalance:amount];
}

- (void)closeSonect {
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sonect:(SNCSonect *)sonect loadAvailablePaymentMethodsForContext:(SNCPaymentContext)context handler:(SNCPaymentMethodsHandler)handler {
    handler(self.paymentMethods, nil);
}

- (PaymentMethod *)paymentMethodWithUniqueIdentifier:(NSString *)uniqueIdentifier {
    for (PaymentMethod *paymentMethod in self.paymentMethods) {
        if ([paymentMethod.uniqueIdentifier isEqualToString:uniqueIdentifier]) {
            return paymentMethod;
        }
    }

    NSAssert1(NO, @"No payment method with id %@", uniqueIdentifier);
    return nil;
}

@end
