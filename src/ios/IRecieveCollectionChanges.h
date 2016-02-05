//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
@protocol IRecieveCollectionChanges <NSObject>

@required
- (void) add:(NSObject*)collection item:(NSObject*)item;
- (void) removeAt:(NSObject*)collection index:(int)index;

@end
