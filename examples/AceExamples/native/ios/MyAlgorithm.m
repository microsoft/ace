#import "MyAlgorithm.h"

@implementation MyAlgorithm

- (void)setStartingNumber: (int)n {
	_startingNumber = n;
}

- (int)getNextPrime {
	int n = _startingNumber;
	while (![MyAlgorithm isPrime:n]) {
		n++;
	}
	_startingNumber = n + 1;
	return n;
}

+ (BOOL)isPrime: (int)n {
	// assert n > 0;

	if (n <= 2)
		return YES;

	// No even numbers > 2 are prime
	if (n % 2 == 0)
		return NO;

	// Check all possible odd factors up to the square root of n
	for (int i = 3; i*i <= n; i+=2) {
		if (n % i == 0)
			return NO;
	}
	return YES;
}

@end