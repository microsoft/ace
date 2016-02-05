//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "PathSegmentCollection.h"

@interface PathFigure : NSObject

@property bool IsClosed;
@property CGPoint startPoint;
@property bool IsFilled;
@property PathSegmentCollection* Segments;

@end
