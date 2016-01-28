#import "Brush.h"

@interface BrushConverter : NSObject

+ (Brush*)parse:(NSString*)text;

@end
