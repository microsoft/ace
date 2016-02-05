//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@interface Dictionary : NSObject
{
    NSMutableDictionary* _dictionary;
}

@property (readonly) unsigned long Count;

- (void)Add:(id)key value:(id)obj;

// For indexing:
- (id)objectForKeyedSubscript:(id <NSCopying>)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

@end
