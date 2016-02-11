//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "IHaveProperties.h"

@interface Popup : UIView <IHaveProperties>
{
    UIView* _content;
    BOOL _isFullScreen;
	BOOL _hasExplicitSize;
    CGFloat _explicitX;
    CGFloat _explicitY;
    CGFloat _explicitWidth;
    CGFloat _explicitHeight;
}

+ (void) CloseAll;

@end
