//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "GeometryContext.h"
#import "LineSegment.h"
#import "PolyLineSegment.h"
#import "BezierSegment.h"
#import "PolyBezierSegment.h"
#import "QuadraticBezierSegment.h"
#import "PolyQuadraticBezierSegment.h"
#import "ArcSegment.h"
#import "PathSegmentCollection.h"

enum FillRule s_defaultFillRule;
bool s_defaultValueForPathFigureIsClosed;
bool s_defaultValueForPathFigureIsFilled;
CGPoint s_defaultValueForPathFigureStartPoint;
bool s_defaultValueForPathSegmentIsStroked;
bool s_defaultValueForPathSegmentIsSmoothJoin;
bool s_defaultValueForArcSegmentIsLargeArc;
enum SweepDirection s_defaultValueForArcSegmentSweepDirection;
double s_defaultValueForArcSegmentRotationAngle;

@implementation GeometryContext

- (id) initWithGeometry:(PathGeometry*) g {
    self = [super init];

    _pathGeometry = g;

    return self;
}

- (void) Close {
  [self FinishSegment];
}

- (void) BeginFigure:(CGPoint) startPoint isFilled:(bool)isFilled isClosed:(bool)isClosed {
    // Is this the first figure?
    if (_currentFigure == nil) {
        // If so, have we allocated the collection?
        if (_figures == nil) {
            _figures = [[PathFigureCollection alloc] init];
            _pathGeometry.figures = _figures;
        }
    }

    [self FinishSegment];

    // Clear the old reference to the segment collection
    _segments = nil;

    _currentFigure = [[PathFigure alloc] init];
    _currentIsClosed = isClosed;

    if (startPoint.x != s_defaultValueForPathFigureStartPoint.x
     || startPoint.y != s_defaultValueForPathFigureStartPoint.y) {
        _currentFigure.startPoint = startPoint;
    }

    if (isClosed != s_defaultValueForPathFigureIsClosed) {
        _currentFigure.IsClosed = isClosed;
    }

    if (isFilled != s_defaultValueForPathFigureIsFilled) {
        _currentFigure.IsFilled = isFilled;
    }

    [_figures Add:_currentFigure];

    _currentSegmentType = SegmentTypeNone;
}

- (void) LineTo:(CGPoint) point isStroked:(bool)isStroked isSmoothJoin:(bool)isSmoothJoin {
    [self PrepareToAddPoints:1 isStroked:isStroked isSmoothJoin:isSmoothJoin segmentType:SegmentTypePolyLine];
    [_currentSegmentPoints Add:[NSValue valueWithCGPoint:point]];
}

- (void) QuadraticBezierTo:(CGPoint) point1 point2:(CGPoint)point2 isStroked:(bool)isStroked isSmoothJoin:(bool)isSmoothJoin {
    [self PrepareToAddPoints:2 isStroked:isStroked isSmoothJoin:isSmoothJoin segmentType:SegmentTypePolyQuadraticBezier];
    [_currentSegmentPoints Add:[NSValue valueWithCGPoint:point1]];
    [_currentSegmentPoints Add:[NSValue valueWithCGPoint:point2]];
}

- (void) BezierTo:(CGPoint) point1 point2:(CGPoint)point2 point3:(CGPoint)point3
          isStroked:(bool)isStroked isSmoothJoin:(bool)isSmoothJoin {
    [self PrepareToAddPoints:3 isStroked:isStroked isSmoothJoin:isSmoothJoin segmentType:SegmentTypePolyBezier];
    [_currentSegmentPoints Add:[NSValue valueWithCGPoint:point1]];
    [_currentSegmentPoints Add:[NSValue valueWithCGPoint:point2]];
    [_currentSegmentPoints Add:[NSValue valueWithCGPoint:point3]];
}

- (void) PolyLineTo:(NSArray*) points isStroked:(bool)isStroked isSmoothJoin:(bool)isSmoothJoin {
    [self GenericPolyTo:points isStroked:isStroked isSmoothJoin:isSmoothJoin segmentType:SegmentTypePolyLine];
}

- (void) PolyQuadraticBezierTo:(NSArray*) points isStroked:(bool)isStroked isSmoothJoin:(bool)isSmoothJoin {
    [self GenericPolyTo:points isStroked:isStroked isSmoothJoin:isSmoothJoin segmentType:SegmentTypePolyQuadraticBezier];
}

- (void) PolyBezierTo:(NSArray*) points isStroked:(bool)isStroked isSmoothJoin:(bool)isSmoothJoin {
    [self GenericPolyTo:points isStroked:isStroked isSmoothJoin:isSmoothJoin segmentType:SegmentTypePolyBezier];
}

- (void) ArcTo:(CGPoint) point size:(CGPoint)size rotationAngle:(double)rotationAngle isLargeArc:(bool)isLargeArc
          sweepDirection:(enum SweepDirection)sweepDirection isStroked:(bool)isStroked isSmoothJoin:(bool)isSmoothJoin {
    [self FinishSegment];

    // Is this the first segment?
    if (_segments == nil) {
        _segments = [[PathSegmentCollection alloc] init];
        _currentFigure.Segments = _segments;
    }

    ArcSegment* segment = [[ArcSegment alloc] init];
    segment.Point = point;
    segment.Size = size;

    if (isLargeArc != s_defaultValueForArcSegmentIsLargeArc) {
        segment.IsLargeArc = isLargeArc;
    }

    if (sweepDirection != s_defaultValueForArcSegmentSweepDirection) {
        segment.SweepDirection = sweepDirection;
    }

    if (rotationAngle != s_defaultValueForArcSegmentRotationAngle) {
        segment.RotationAngle = rotationAngle;
    }

    if (isStroked != s_defaultValueForPathSegmentIsStroked) {
        segment.IsStroked = isStroked;
    }

    if (isSmoothJoin != s_defaultValueForPathSegmentIsSmoothJoin) {
        segment.IsSmoothJoin = isSmoothJoin;
    }

    [_segments Add:segment];

    _currentSegmentType = SegmentTypeArc;
}

- (void) SetClosedState:(bool) isClosed {
    if (isClosed != _currentIsClosed) {
        _currentFigure.IsClosed = isClosed;
        _currentIsClosed = isClosed;
    }
}

- (void) SetFigureCount:(int) figureCount {
    // TODO: This ignores the count
    _figures = [[PathFigureCollection alloc] init];
    _pathGeometry.figures = _figures;
}

- (void) SetSegmentCount:(int) segmentCount {
    // TODO: This ignores the count
    _segments = [[PathSegmentCollection alloc] init];
    _currentFigure.Segments = _segments;
}

- (void) GenericPolyTo:(NSArray*) points
             isStroked:(bool) isStroked
          isSmoothJoin:(bool) isSmoothJoin
           segmentType:(int) segmentType {
    int count = (int)points.count;
    [self PrepareToAddPoints:count isStroked:isStroked isSmoothJoin:isSmoothJoin segmentType:segmentType];

    for (int i = 0; i < count; i++) {
        [_currentSegmentPoints Add:points[i]];
    }
}

- (void) PrepareToAddPoints:(int) count
                  isStroked:(bool)isStroked
               isSmoothJoin:(bool)isSmoothJoin
                segmentType:(int) segmentType {
    if (_currentSegmentType != segmentType ||
        _currentSegmentIsStroked != isStroked ||
        _currentSegmentIsSmoothJoin != isSmoothJoin) {
        [self FinishSegment];

        _currentSegmentType = (enum SegmentType)segmentType;
        _currentSegmentIsStroked = isStroked;
        _currentSegmentIsSmoothJoin = isSmoothJoin;
    }

    if (_currentSegmentPoints == nil) {
        _currentSegmentPoints = [[PointCollection alloc] init];
    }
}

- (void) FinishSegment {
    if (_currentSegmentPoints != nil) {
        int count = (int)_currentSegmentPoints.Count;

        // Is this the first segment?
        if (_segments == nil) {
            _segments = [[PathSegmentCollection alloc] init];
            _currentFigure.Segments = _segments;
        }

        PathSegment* segment;

        switch (_currentSegmentType) {
            case SegmentTypePolyLine:
                if (count == 1) {
                    LineSegment* lSegment = [[LineSegment alloc] init];
                    lSegment.Point = [_currentSegmentPoints[0] CGPointValue];
                    segment = lSegment;
                }
                else {
                    PolyLineSegment* pSegment = [[PolyLineSegment alloc] init];
                    pSegment.Points = _currentSegmentPoints;
                    segment = pSegment;
                }
                break;
            case SegmentTypePolyBezier:
                if (count == 3) {
                    BezierSegment* bSegment = [[BezierSegment alloc] init];
                    bSegment.Point1 = [_currentSegmentPoints[0] CGPointValue];
                    bSegment.Point2 = [_currentSegmentPoints[1] CGPointValue];
                    bSegment.Point3 = [_currentSegmentPoints[2] CGPointValue];
                    segment = bSegment;
                }
                else {
                    PolyBezierSegment* pSegment = [[PolyBezierSegment alloc] init];
                    pSegment.Points = _currentSegmentPoints;
                    segment = pSegment;
                }
                break;
            case SegmentTypePolyQuadraticBezier:
                if (count == 2) {
                    QuadraticBezierSegment* qSegment = [[QuadraticBezierSegment alloc] init];
                    qSegment.Point1 = [_currentSegmentPoints[0] CGPointValue];
                    qSegment.Point2 = [_currentSegmentPoints[1] CGPointValue];
                    segment = qSegment;
                }
                else {
                    PolyQuadraticBezierSegment* pSegment = [[PolyQuadraticBezierSegment alloc] init];
                    pSegment.Points = _currentSegmentPoints;
                    segment = pSegment;
                }
                break;
            default:
                segment = nil;
                break;
        }

        if (_currentSegmentIsStroked != s_defaultValueForPathSegmentIsStroked) {
            segment.IsStroked = _currentSegmentIsStroked;
        }

        if (_currentSegmentIsSmoothJoin != s_defaultValueForPathSegmentIsSmoothJoin) {
            segment.IsSmoothJoin = _currentSegmentIsSmoothJoin;
        }

        [_segments Add:segment];

        _currentSegmentPoints = nil;
        _currentSegmentType = SegmentTypeNone;
    }
}

@end
