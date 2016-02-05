//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
@interface MyAlgorithm : NSObject
{
	int _startingNumber;
}

- (void)setStartingNumber:(int)n;
- (int)getNextPrime;
+ (BOOL)isPrime:(int)n;

@end
