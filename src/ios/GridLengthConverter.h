//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "GridLength.h"

@interface GridLengthConverter : NSObject

+ (GridLength*)parse:(NSString*)text;

@end
