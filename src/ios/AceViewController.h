//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
@interface AceViewController : UIViewController

@property UIView* content;

- (id)initWithContent:(UIView*)view navigationController:(UINavigationController*)navigationController;

@end
