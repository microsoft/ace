//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
@protocol IHaveProperties <NSObject>

@required
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue;

@end
