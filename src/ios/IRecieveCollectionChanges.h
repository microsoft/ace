@protocol IRecieveCollectionChanges <NSObject>

@required
- (void) add:(NSObject*)collection item:(NSObject*)item;
- (void) removeAt:(NSObject*)collection index:(int)index;

@end