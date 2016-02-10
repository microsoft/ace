//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "PathGeometry.h"
#import "PathFigure.h"
#import "PathSegment.h"
#import "LineSegment.h"
#import "PolyLineSegment.h"
#import "ArcSegment.h"
#import "BezierSegment.h"
#import "PolyBezierSegment.h"
#import "QuadraticBezierSegment.h"
#import "PolyQuadraticBezierSegment.h"

@implementation PathGeometry

- (id) init {
    self = [super init];

    // Default property values
    self.fillRule = EvenOdd;

    return self;
}

- (CGRect)bounds {
    double minX = 0;
    double maxX = 0;
    double minY = 0;
    double maxY = 0;

    // Loop thru figures
    PathFigureCollection* figures = self.figures;
    for (int i = 0; i < [figures Count]; i++) {
        PathFigure* figure = figures[i];

        CGPoint p = figure.startPoint;
        minX = MIN(minX, p.x);
        minY = MIN(minY, p.y);
        maxX = MAX(maxX, p.x);
        maxY = MAX(maxY, p.y);

        // Loop thru segments
        PathSegmentCollection* segments = figure.Segments;
        for (int j = 0; j < [segments Count]; j++) {
            PathSegment* segment = segments[j];

            if ([segment isKindOfClass:[LineSegment class]]) {
                p = ((LineSegment*)segment).Point;
                minX = MIN(minX, p.x);
                minY = MIN(minY, p.y);
                maxX = MAX(maxX, p.x);
                maxY = MAX(maxY, p.y);
            }
            else if ([segment isKindOfClass:[PolyLineSegment class]]) {
                PointCollection* points = ((PolyLineSegment*)segments[j]).Points;
                for (int k = 0; k < points.Count; k++)
                {
                    p = [points[k] CGPointValue];
                    minX = MIN(minX, p.x);
                    minY = MIN(minY, p.y);
                    maxX = MAX(maxX, p.x);
                    maxY = MAX(maxY, p.y);
                }
            }
            else if ([segment isKindOfClass:[ArcSegment class]]) {
                //TODO: Not right
                p = ((ArcSegment*)segment).Point;
                minX = MIN(minX, p.x + ((ArcSegment*)segment).Size.x);
                minY = MIN(minY, p.y + ((ArcSegment*)segment).Size.y);
                maxX = MAX(maxX, p.x + ((ArcSegment*)segment).Size.x);
                maxY = MAX(maxY, p.y + ((ArcSegment*)segment).Size.y);
            }
            else if ([segment isKindOfClass:[BezierSegment class]]) {
                //TODO: Not right
                p = ((BezierSegment*)segment).Point1;
                minX = MIN(minX, p.x);
                minY = MIN(minY, p.y);
                maxX = MAX(maxX, p.x);
                maxY = MAX(maxY, p.y);
                p = ((BezierSegment*)segment).Point2;
                minX = MIN(minX, p.x);
                minY = MIN(minY, p.y);
                maxX = MAX(maxX, p.x);
                maxY = MAX(maxY, p.y);
                p = ((BezierSegment*)segment).Point3;
                minX = MIN(minX, p.x);
                minY = MIN(minY, p.y);
                maxX = MAX(maxX, p.x);
                maxY = MAX(maxY, p.y);
            }
            else if ([segment isKindOfClass:[PolyBezierSegment class]]) {
                //TODO: Not right
                PointCollection* points = ((PolyLineSegment*)segments[j]).Points;
                for (int k = 0; k < points.Count; k++)
                {
                    p = [points[k] CGPointValue];
                    minX = MIN(minX, p.x);
                    minY = MIN(minY, p.y);
                    maxX = MAX(maxX, p.x);
                    maxY = MAX(maxY, p.y);
                }
            }
            else if ([segment isKindOfClass:[QuadraticBezierSegment class]]) {
                //TODO: Not right
                p = ((BezierSegment*)segment).Point1;
                minX = MIN(minX, p.x);
                minY = MIN(minY, p.y);
                maxX = MAX(maxX, p.x);
                maxY = MAX(maxY, p.y);
                p = ((BezierSegment*)segment).Point2;
                minX = MIN(minX, p.x);
                minY = MIN(minY, p.y);
                maxX = MAX(maxX, p.x);
                maxY = MAX(maxY, p.y);
            }
            else if ([segment isKindOfClass:[PolyQuadraticBezierSegment class]]) {
                //TODO: Not right
                PointCollection* points = ((PolyLineSegment*)segments[j]).Points;
                for (int k = 0; k < points.Count; k++)
                {
                    p = [points[k] CGPointValue];
                    minX = MIN(minX, p.x);
                    minY = MIN(minY, p.y);
                    maxX = MAX(maxX, p.x);
                    maxY = MAX(maxY, p.y);
                }
            }
            else {
                throw [NSString stringWithFormat:@"NYI: segment of type %@", [segment class]];
            }
        }
    }

    //TODO: Not correct due to miter corners, etc...
    return CGRectMake(0, 0, maxX + 1, maxY + 1);
}

- (void)setBounds:(CGRect)newValue {
    throw @"Bounds NYI";
}

@end
