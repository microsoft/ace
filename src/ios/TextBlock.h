//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "IHaveProperties.h"

enum TextAlignment { TextAlignmentCenter, TextAlignmentLeft, TextAlignmentRight, TextAlignmentJustify };

@interface TextBlock : UILabel <IHaveProperties>

@property UIEdgeInsets padding;

@end
