//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Selector.h"

@interface ListBox : Selector<IRecieveCollectionChanges, UITableViewDelegate, UITableViewDataSource>
{
    UITableView* _tv;
}

// TODO: Currently here for the benefit of ListView
@property id Header;

@end
