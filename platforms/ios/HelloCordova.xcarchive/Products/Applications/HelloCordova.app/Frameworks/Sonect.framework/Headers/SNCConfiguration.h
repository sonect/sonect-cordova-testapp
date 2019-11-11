//
//  SNCConfiguration.h
//  SonectSDK
//
//  Created by Bruno Sousa on 21/12/2018.
//  Copyright © 2018 Sonect. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNCConfiguration : NSObject

/**
 A 2 digit ISO country code i.e. "ch" for Switzerland
 */
@property (nonatomic, nullable, copy, readonly) NSString* alpha2CountryCode;

/**
 The user's preferred currency i.e. "CHF" for Swiss Francs
 */
@property (nonatomic, nullable, copy, readonly) NSString* currency;

/**
 Set allowed country codes.
 Example: would be US and Switzerland
 @[@1, @41]
 */
@property (nonatomic, nullable, copy, readonly) NSArray <NSNumber *> *allowedCountryCodes;

/**
 A default withdraw amount index in the Withdraw View Controller amount picker control.
 This control also remembers the user's last picked value.
 */
@property (nonatomic, readonly) NSUInteger defaultWithdrawAmountIndex;

/**
 This value determines if upon opening the SDK, the user should be presented with an
 active transaction.
 @default NO
 */
@property (nonatomic, readonly) BOOL shouldPresentTransactionIfAvailable;

/**
 Initializes the configuration with a designated configuration plist file.

 @param filePath a file path.
 @return a configuration.
 */
- (instancetype)initWithContentsOfFile:(NSString *)filePath;

/**
 Initializes the configuration by loading the SonectConfiguration.plist

 @return a configuration.
 */
+ (instancetype)defaultConfiguration;

+ (instancetype) new  NS_UNAVAILABLE;
- (instancetype) init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
