//
//  UIImage+SNCSDKColorize.h
//  Sonect
//
//  Created by Ivan Yanakiev on 24.07.19.
//  Copyright © 2019 Sonect. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SNCSDKColorize)

- (UIImage *)sncsdk_colorized:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
