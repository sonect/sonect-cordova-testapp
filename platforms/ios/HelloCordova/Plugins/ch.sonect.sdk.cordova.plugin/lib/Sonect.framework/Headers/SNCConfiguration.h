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
 A 2 digit ISO country code.
 */
@property(nonatomic, copy, readonly) NSString* alpha2CountryCode;

/**
 The user's preferred currency
 */
@property(nonatomic, copy, readonly) NSString* currency;

/**
 Set allowed country codes.
 Example: would be US and Switzerland
 @[@1, @41]
 */
@property(nonatomic, copy, readonly) NSArray <NSNumber *> *allowedCountryCodes;

- (instancetype)initWithAlpha2CountryCode:(NSString *)alpha2CountryCode
                                 currency:(NSString *)currency
                      allowedCountryCodes:(NSArray <NSNumber *> *)allowedCountryCodes;

@end

NS_ASSUME_NONNULL_END
