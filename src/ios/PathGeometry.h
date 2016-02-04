#import "Geometry.h"
#import "PathFigureCollection.h"

enum SegmentType {
    SegmentTypeNone,
    SegmentTypeLine,
    SegmentTypeBezier,
    SegmentTypeQuadraticBezier,
    SegmentTypeArc,
    SegmentTypePolyLine,
    SegmentTypePolyBezier,
    SegmentTypePolyQuadraticBezier
};

@interface PathGeometry : Geometry

@property PathFigureCollection* figures;
@property int fillRule;

@end
