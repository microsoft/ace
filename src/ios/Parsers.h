#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Brush.h"

@interface Parsers : NSObject

+ (int) ParseHexChar:(char) c;
+ (UIColor*) ParseHexColor:(NSString*) trimmedColor;
+ (UIColor*) ParseColor:(NSString*) color;
+ (Brush*) ParseBrush:(NSString*) brush;

@end
