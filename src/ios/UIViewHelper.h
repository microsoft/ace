#define UIColorFromARGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:((float)((rgbValue & 0xFF000000) >> 24))/255.0];

@interface UIViewHelper : NSObject

+ (BOOL) setProperty:(UIView*)instance propertyName:(NSString*)propertyName propertyValue:(NSObject*)propertyValue;

@end
