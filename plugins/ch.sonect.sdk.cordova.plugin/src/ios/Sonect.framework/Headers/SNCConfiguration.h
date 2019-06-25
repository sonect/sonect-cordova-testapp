//
//  SNCConfiguration.h
//  SonectSDK
//
//  Created by Bruno Sousa on 21/12/2018.
//  Copyright © 2018 Sonect. All rights reserved.
//

#ifndef SNCConfiguration_h
#define SNCConfiguration_h

#import <Foundation/Foundation.h>

@class SNCToken;
@class SNCTheme;

@interface SNCConfiguration : NSObject

/**
 A token.
 */
@property(nonatomic, strong, readonly) SNCToken* token;

/**
 The theme.
 */
@property(nonatomic, strong, readonly) SNCTheme* theme;

/**
 The user's preferred currency
 */
@property(nonatomic, strong, readonly) NSString* currency;

/**
 Set allowed country codes.
 Example: would be US and Switzerland
 @[@1, @41]
 */
@property(nonatomic, strong, readonly) NSArray <NSNumber *> *allowedCountryCodes;

- (instancetype)initWithToken:(SNCToken *)token
                        theme:(SNCTheme *)theme
                     currency:(NSString *)currency
          allowedCountryCodes:(NSArray <NSNumber *> *)allowedCountryCodes;

@end

#endif /* SNCConfiguration_h */
