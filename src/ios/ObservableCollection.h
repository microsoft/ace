//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "IRecieveCollectionChanges.h"

@interface ObservableCollection : NSObject
{
    NSMutableArray* _array;
	NSMutableArray* _listeners;
}

@property (readonly) unsigned long Count;

- (void)addListener:(NSObject<IRecieveCollectionChanges>*)listener;
- (void)removeListener:(NSObject<IRecieveCollectionChanges>*)listener;

- (void)Add:(id)obj;
- (void)Clear;
- (void)Remove:(id)obj;
- (void)RemoveAt:(int)index;
- (void)Insert:(int)index object:(id)obj;
- (void)Set:(int)index object:(id)obj;

// For indexing:
- (id)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)index;

@end
