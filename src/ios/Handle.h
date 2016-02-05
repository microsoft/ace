//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
@interface AceHandle : NSObject
{
	int _value;
	BOOL _fromNative;
}

//TODO: Lifetime
// Can't really do weak references without cumbersome client API for keeping things alive.
// Need to expose reasonable destruction APIs, some automatic with trees of UI objects.
+ (NSMutableArray*) _objectsAssignedOnManagedSide;
+ (NSMutableArray*) _objectsAssignedOnNativeSide;

+ (AceHandle*) createFromValue:(int)value fromNative:(BOOL)fromNative;

+ (AceHandle*) fromObject:(NSObject*)obj;
+ (AceHandle*) fromJSON:(NSDictionary*)obj;
- (NSObject*) toObject;
- (NSDictionary*) toJSON;
+ (NSObject*) deserialize:(NSDictionary*)obj;

- (void) register:(NSObject*)instance;
- (void) assign:(NSObject*)instance list:(NSMutableArray*)list;

@end
