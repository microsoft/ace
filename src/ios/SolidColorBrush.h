#import "Brush.h"

@interface SolidColorBrush : Brush
{
    UIColor* _Color;
}

@property UIColor* Color;

- (id)initWithColor:(UIColor*) color;

@end
