//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Brush.h"

@interface Parsers : NSObject

+ (int) ParseHexChar:(char) c;
+ (UIColor*) ParseHexColor:(NSString*) trimmedColor;
+ (UIColor*) ParseColor:(NSString*) color;
+ (Brush*) ParseBrush:(NSString*) brush;

@end
