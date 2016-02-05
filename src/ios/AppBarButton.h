//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Button.h"
#import "IconElement.h"

@interface AppBarButton : Button
{
    IconElement* _Icon;
    UIBarButtonItem* _ToolbarItem;
}

@property NSString* Label;
@property IconElement* Icon;
@property UIBarButtonItem* ToolbarItem;

@property bool hasSystemIcon;
@property UIBarButtonSystemItem systemIcon;

@end
