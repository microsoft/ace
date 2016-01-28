#import "BrushConverter.h"
#import "Parsers.h"

@implementation BrushConverter

+ (Brush*)parse:(NSString*)text {
    return [Parsers ParseBrush:text];
}

@end
