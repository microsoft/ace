@interface Thickness : NSObject

@property double left;
@property double top;
@property double right;
@property double bottom;

+ (NSObject*) deserialize:(NSDictionary*)obj;
+ (Thickness*) parse:(NSString*)text;
+ (Thickness*) fromNumber:(NSNumber*)number;

@end
