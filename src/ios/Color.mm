#import "Color.h"
#import "BrushConverter.h"
#import "SolidColorBrush.h"

#define UIColorFromARGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:((float)((rgbValue & 0xFF000000) >> 24))/255.0];

@implementation Color

+ (UIColor*)fromObject:(NSObject*)value withDefault:(UIColor*)defaultValue {
    if (value == nil) {
        return defaultValue;
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
        // It's a raw color value
        return UIColorFromARGB([(NSNumber*)value intValue]);
    }
    else if ([value isKindOfClass:[NSString class]]) {
        Brush* brush = [BrushConverter parse:(NSString*)value];
        return ((SolidColorBrush*)brush).Color;
    }
    else if ([value isKindOfClass:[SolidColorBrush class]]) {
        return ((SolidColorBrush*)value).Color;
    }
    else {
        throw [NSString stringWithFormat:@"Cannot get a color from unsupported object type %@", object_getClassName(value)];
    }
}

@end
