//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

@interface CustomActionSheet : UIView
{
    UIView* _customView;
    UIButton* _dismissBackground;
}

@property UIView* Child;

- (void) Show;
- (void) dismiss:(id)sender;

@end
