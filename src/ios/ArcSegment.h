#import "PathSegment.h"

@interface ArcSegment : PathSegment

@property CGPoint Point;
@property CGPoint Size;
@property bool IsLargeArc;
@property int SweepDirection;
@property double RotationAngle;

@end
