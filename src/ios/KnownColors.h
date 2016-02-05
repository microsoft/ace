//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
@interface KnownColors : NSObject

+ (NSString*) ColorStringToKnownColor:(NSString*) colorString;
+ (NSString*) MatchColor:(NSString*) colorString isKnownColor:(bool*) isKnownColor isNumericColor:(bool*) isNumericColor isContextColor:(bool*) isContextColor isScRgbColor:(bool*) isScRgbColor;

@end
