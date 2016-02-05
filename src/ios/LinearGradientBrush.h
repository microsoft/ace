//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Brush.h"
#import "GradientStopCollection.h"

@interface LinearGradientBrush : Brush

@property CGPoint startPoint;
@property CGPoint endPoint;
@property GradientStopCollection* gradientStops;

@end
