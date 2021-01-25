//
//  UIColor+SNCSonect.h
//  Sonect
//
//  Created by Marko Hlebar on 22/07/2019.
//  Copyright © 2019 Sonect. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (SNCSonect)

+ (UIColor * _Nonnull)sncsdk_greyColor;
+ (UIColor * _Nonnull)sncsdk_lightGreyColor;
+ (UIColor * _Nonnull)sncsdk_flamingoColor;
+ (UIColor * _Nonnull)sncsdk_orangeYellowColor;
+ (UIColor * _Nonnull)sncsdk_greyishBrownColor;
+ (UIColor * _Nonnull)sncsdk_greenyYellowColor;
+ (UIColor * _Nonnull)sncsdk_warmGreyColor;
+ (UIColor * _Nonnull)sncsdk_blackTwoColor;
+ (UIColor * _Nonnull)sncsdk_scarletColor;
+ (UIColor * _Nonnull)sncsdk_outlinesBlackColor;
+ (UIColor * _Nonnull)sncsdk_blackFourColor;
+ (UIColor * _Nonnull)sncsdk_softBlueColor;
+ (UIColor * _Nonnull)sncsdk_redVioletColor;
+ (UIColor * _Nonnull)sncsdk_squashColor;
+ (UIColor * _Nonnull)sncsdk_blackColor;
+ (UIColor * _Nonnull)sncsdk_greyishBrownStatusColor;
+ (UIColor * _Nonnull)sncsdk_reddishPinkColor;
+ (UIColor * _Nonnull)sncsdk_charcoalGreyColor;
+ (UIColor * _Nonnull)sncsdk_blackThreeColor;
+ (UIColor * _Nonnull)sncsdk_sunflowerYellowColor;
+ (UIColor * _Nonnull)sncsdk_royalPurpleColor;
+ (UIColor * _Nonnull)sncsdk_blackFiveColor;
+ (UIColor * _Nonnull)sncsdk_blackSixColor;
+ (UIColor * _Nonnull)sncsdk_blackSevenColor;
+ (UIColor * _Nonnull)sncsdk_whiteColor;
+ (UIColor * _Nonnull)sncsdk_greenBlueColor;
+ (UIColor * _Nonnull)sncsdk_butterscotchColor;
+ (UIColor * _Nonnull)sncsdk_blackEightColor;

+ (UIColor * _Nonnull)sncsdk_backgroundColor;
+ (UIColor * _Nonnull)sncsdk_titleTextColor; // for text over sncsdk_backgroundColor
+ (UIColor * _Nonnull)sncsdk_tileBackgroundColor;
+ (UIColor * _Nonnull)sncsdk_generalTintActiveColor; // corresponds to bar's buttons tint
+ (UIColor * _Nonnull)sncsdk_generalTintBackgroundColor; // limit bar's not filled part
+ (UIColor * _Nonnull)sncsdk_generalTintContrastColor; // used primarily for titles on generalTint background
+ (UIColor * _Nonnull)sncsdk_accentContrastColor; // as oppose to generalTitleText color
@end

NS_ASSUME_NONNULL_END
