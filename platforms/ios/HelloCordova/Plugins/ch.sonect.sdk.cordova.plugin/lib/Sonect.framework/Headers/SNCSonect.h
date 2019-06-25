//
//  SNCSonect.h
//  Sonect
//
//  Created by Marko Hlebar on 07/12/2018.
//  Copyright © 2018 Sonect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNCSonectPaymentDataSource.h"

NS_ASSUME_NONNULL_BEGIN

//@protocol SNCSonectPaymentDataSource;
@class SNCConfiguration, UIViewController;
@interface SNCSonect : NSObject
@property (class, nullable, readonly) SNCConfiguration *currentConfiguration;

+ (UIViewController *)makeViewControllerWithConfiguration:(SNCConfiguration *)configuration
                                               dataSource:(id <SNCSonectPaymentDataSource> _Nullable)dataSource;

@end

NS_ASSUME_NONNULL_END
