//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Dictionary.h"

@implementation Dictionary

- (id)init {
    self = [super init];
    _dictionary = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)Add:(id)key value:(id)obj {
    [_dictionary setObject:obj forKey:key];
}

- (unsigned long)Count {
    return _dictionary.count;
}

- (id)objectForKeyedSubscript:(id <NSCopying>)key {
    return _dictionary[key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key {
    [_dictionary setObject:obj forKey:key];
}

@end
