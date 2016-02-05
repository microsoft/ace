//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "IHaveProperties.h"
#import "CommandBar.h"

@interface Page : UIView <IHaveProperties>
{
    CommandBar* _topAppBar;
    NSObject* _bottomAppBar;
    UIView* _content;
}

@property NSString* frameTitle;

- (NSObject*)getBottomAppBar;
- (CommandBar*)getTopAppBar;

@end
