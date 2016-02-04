#import "Brush.h"
#import "GradientStopCollection.h"

@interface LinearGradientBrush : Brush

@property CGPoint startPoint;
@property CGPoint endPoint;
@property GradientStopCollection* gradientStops;

@end
