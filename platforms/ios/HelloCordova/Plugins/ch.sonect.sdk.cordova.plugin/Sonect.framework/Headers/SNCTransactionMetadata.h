//
//  SNCTransactionMetadata.h
//  Sonect
//
//  Created by Marko Hlebar on 07/03/2019.
//  Copyright © 2019 Sonect. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *const SNCTransactionMetadataKey NS_STRING_ENUM;

FOUNDATION_EXPORT SNCTransactionMetadataKey SNCTransactionMetadataKeyAmount;
FOUNDATION_EXPORT SNCTransactionMetadataKey SNCTransactionMetadataKeyCurrency;
FOUNDATION_EXPORT SNCTransactionMetadataKey SNCTransactionMetadataKeyOpen;
FOUNDATION_EXPORT SNCTransactionMetadataKey SNCTransactionMetadataKeyPaymentId;
FOUNDATION_EXPORT SNCTransactionMetadataKey SNCTransactionMetadataKeyPaymentMethodId;
FOUNDATION_EXPORT SNCTransactionMetadataKey SNCTransactionMetadataKeyPaymentMethod;
FOUNDATION_EXPORT SNCTransactionMetadataKey SNCTransactionMetadataKeyTo;
FOUNDATION_EXPORT SNCTransactionMetadataKey SNCTransactionMetadataKeyType;
FOUNDATION_EXPORT SNCTransactionMetadataKey SNCTransactionMetadataKeyTrxType;

@protocol SNCTransactionMetadata <NSObject>

/**
 Implement me in a subclass.
 */
@property (nonnull, readonly) NSDictionary <SNCTransactionMetadataKey, NSString *> *serialized;
@end

NS_ASSUME_NONNULL_END
