//
//  SNCTransactionAmount.h
//  Sonect
//
//  Created by Marko Hlebar on 19/03/2019.
//  Copyright © 2019 Sonect. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNCTransactionAmount : NSObject

/**
 Amount of money to do transaction with.
 */
@property (nonatomic, copy, readonly) NSDecimalNumber *value;

/**
 Currency code. i.e. CHF
 */
@property (nonatomic, copy, readonly) NSString *currency;

/**
 Creates a transaction amount object.

 @param value a value, amount of money to do transaction with.
 @param currency a currency code. i.e. CHF
 @return a transaction amount object.
 */
+ (instancetype)transactionAmountWithValue:(NSDecimalNumber *)value currency:(NSString *)currency;

/**
 Returns a 0 amount in a currency.

 @param currency a currency.
 @return an amount.
 */
+ (instancetype)zeroAmountWithCurrency:(NSString *)currency;
@end

NS_ASSUME_NONNULL_END
