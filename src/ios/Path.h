//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Shape.h"
#import "Geometry.h"
#import "IHaveProperties.h"

// Can be true in order to have the system gloss over
// presumably-temporary errors like a null color in a gradient
#define DESIGNERMODE false

@interface Path : Shape <IHaveProperties>

@property Geometry* data;

@end
