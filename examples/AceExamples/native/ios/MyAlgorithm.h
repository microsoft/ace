@interface MyAlgorithm : NSObject
{
	int _startingNumber;
}

- (void)setStartingNumber:(int)n;
- (int)getNextPrime;
+ (BOOL)isPrime:(int)n;

@end
