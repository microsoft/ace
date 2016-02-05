//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "PathGeometry.h"
#import "PathFigure.h"
#import "PathFigureCollection.h"
#import "PathSegmentCollection.h"
#import "PointCollection.h"

enum SweepDirection { Counterclockwise = 0, Clockwise = 1 };

@interface GeometryContext : NSObject
{
    PathGeometry* _pathGeometry;
    PathFigureCollection* _figures;
    PathFigure* _currentFigure;
    PathSegmentCollection* _segments;
    bool _currentIsClosed;

    enum SegmentType _currentSegmentType;
    PointCollection* _currentSegmentPoints;
    bool _currentSegmentIsStroked;
    bool _currentSegmentIsSmoothJoin;
}

- (id) initWithGeometry:(PathGeometry*) g;
- (void) SetFigureCount:(int) figureCount;
- (void) BeginFigure:(CGPoint) startPoint isFilled:(bool)isFilled isClosed:(bool)isClosed;
- (void) LineTo:(CGPoint) point isStroked:(bool)isStroked isSmoothJoin:(bool)isSmoothJoin;
- (void) QuadraticBezierTo:(CGPoint) point1 point2:(CGPoint)point2 isStroked:(bool)isStroked isSmoothJoin:(bool)isSmoothJoin;
- (void) BezierTo:(CGPoint) point1 point2:(CGPoint)point2 point3:(CGPoint)point3 isStroked:(bool)isStroked isSmoothJoin:(bool)isSmoothJoin;
- (void) PolyLineTo:(NSArray*) points isStroked:(bool)isStroked isSmoothJoin:(bool)isSmoothJoin;
- (void) PolyQuadraticBezierTo:(NSArray*) points isStroked:(bool)isStroked isSmoothJoin:(bool)isSmoothJoin;
- (void) PolyBezierTo:(NSArray*) points isStroked:(bool)isStroked isSmoothJoin:(bool)isSmoothJoin;
- (void) ArcTo:(CGPoint) point size:(CGPoint)size rotationAngle:(double)rotationAngle isLargeArc:(bool)isLargeArc sweepDirection:(enum SweepDirection)sweepDirection isStroked:(bool)isStroked isSmoothJoin:(bool)isSmoothJoin;
- (void) GenericPolyTo:(NSArray*) points
             isStroked:(bool) isStroked
          isSmoothJoin:(bool) isSmoothJoin
           segmentType:(int) segmentType;
- (void) PrepareToAddPoints:(int) count
                  isStroked:(bool)isStroked
               isSmoothJoin:(bool)isSmoothJoin
                segmentType:(int) segmentType;
- (void) FinishSegment;
- (void) Close;
- (void) SetClosedState:(bool) closed;

@end
