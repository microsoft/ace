//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "GridLength.h"
#import "IHaveProperties.h"

@interface ColumnDefinition : NSObject <IHaveProperties>
{
@public
    GridLength* width;
    double calculatedWidth;
    double calculatedLeft;
}

@end
