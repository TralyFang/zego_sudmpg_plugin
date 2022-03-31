/**
 * Copyright © Sud.Tech
 * https://sud.tech
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef RGBA
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#endif

#ifndef RGB
#define RGB(r, g, b) RGBA(r, g, b, 1.0f)
#endif

/*
 Create UIColor with a hex string.
 Example: UIColorHex(0xF0F), UIColorHex(66ccff), UIColorHex(#66CCFF88)
 
 Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 The `#` or "0x" sign is not required.
 */
#ifndef UIColorHex
#define UIColorHex(_hex_)   [UIColor RW_colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]
#endif


/**
 *  所有方法前面全部加pawf_, 避免与其他接入的库的category重名导致未知问题.
 *  注: colorWithHexString 与接入的某个库有冲突
 */
@interface UIColor (RW)

#pragma mark - Create a UIColor Object
///=============================================================================
/// @name Creating a UIColor Object
///=============================================================================

/**
Creates and returns a color object using the hex RGB color values.

@param rgbValue  The rgb value such as 0x66ccff.

@return          The color object. The color information represented by this
object is in the device RGB colorspace.
*/
+ (UIColor *)RW_colorWithRGB:(uint32_t)rgbValue;

/**
 Creates and returns a color object using the hex RGBA color values.
 
 @param rgbaValue  The rgb value such as 0x66ccffff.

@return           The color object. The color information represented by this
object is in the device RGB colorspace.
 */
+ (UIColor *)RW_colorWithRGBA:(uint32_t)rgbaValue;

/**
 Creates and returns a color object using the specified opacity and RGB hex value.
 
 @param rgbValue  The rgb value such as 0x66CCFF.
 
 @param alpha     The opacity value of the color object,
 specified as a value from 0.0 to 1.0.
 
 @return          The color object. The color information represented by this
 object is in the device RGB colorspace.
 */
+ (UIColor *)RW_colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;

/**
 Creates and returns a color object from hex string.
 
 @discussion:
 Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 The `#` or "0x" sign is not required.
 The alpha will be set to 1.0 if there is no alpha component.
 It will return nil when an error occurs in parsing.
 
 Example: @"0xF0F", @"66ccff", @"#66CCFF88"
 
 @param hexStr  The hex string value for the new color.
 
 @return        An UIColor object from string, or nil if an error occurs.
 */
+ (nullable UIColor *)RW_colorWithHexString:(NSString *)hexStr;

@end

NS_ASSUME_NONNULL_END
