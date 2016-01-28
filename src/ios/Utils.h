@interface Utils : NSObject

+ (UIImage*) getImage:(NSString*)source;
+ (NSObject*) invokeInstanceMethod:(NSObject*)instance methodName:(NSString*)methodName args:(NSArray*)args;
+ (NSObject*) invokeStaticMethod:(NSString*)typeName methodName:(NSString*)methodName args:(NSArray*)args;
+ (NSObject*) deserializeObjectOrStruct:(NSDictionary*)obj;

+ (int) parseInt:(NSString*)s;
+ (void) alert:(NSString*)s;

@end