//
//  SNCCredentials.h
//  Sonect
//
//  Created by Marko Hlebar on 05/07/2019.
//  Copyright © 2019 Sonect. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNCCredentials : NSObject

/**
 An SDK token.
 */
@property(nonatomic, copy, readonly) NSString* sdkToken;

/**
 A user ID.
 */
@property(nonatomic, copy, readonly) NSString* userId;

/**
 A signature.
 */
@property(nonatomic, copy, readonly) NSString* signature;

/**
 A domain.
 */
@property(nonatomic, copy, readonly) NSString* domain;

/**
 Creates credentials to authenticate the SDK.

 @param sdkToken an sdk token.
 @param userId a user id.
 @param signature a signature.
 @param domain a domain.
 @return credentials.
 */
- (instancetype)initWithSdkToken:(NSString *)sdkToken
                          userId:(NSString *)userId
                       signature:(NSString *)signature
                          domain:(NSString *)domain;

@end

NS_ASSUME_NONNULL_END