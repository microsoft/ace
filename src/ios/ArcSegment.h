//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "PathSegment.h"

@interface ArcSegment : PathSegment

@property CGPoint Point;
@property CGPoint Size;
@property bool IsLargeArc;
@property int SweepDirection;
@property double RotationAngle;

@end
