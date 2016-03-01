//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "ImageSource.h"

@interface TableViewCell : UITableViewCell

@property bool IsSelected;

@property ImageSource* Image;
@property NSString* Text;
@property NSString* DetailText;

@end
