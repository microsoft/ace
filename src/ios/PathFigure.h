#import "PathSegmentCollection.h"

@interface PathFigure : NSObject

@property bool IsClosed;
@property CGPoint startPoint;
@property bool IsFilled;
@property PathSegmentCollection* Segments;

@end
