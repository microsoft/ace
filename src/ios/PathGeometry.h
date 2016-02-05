//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
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
