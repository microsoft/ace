#import "Handle.h"

// Used for sending data back (raising events)
@interface OutgoingMessages : NSObject

+ (void) setCallbackContext:(NSObject*)callback selector:(SEL)selector;
+ (void) raiseEvent:(NSString*)eventName instance:(NSObject*)instance eventData:(NSObject*) eventData;
+ (void) raiseEvent:(NSString*)eventName handle:(AceHandle*)handle eventData:(NSObject*) eventData;

@end