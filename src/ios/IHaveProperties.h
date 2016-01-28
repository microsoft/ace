@protocol IHaveProperties <NSObject>

@required
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue;

@end