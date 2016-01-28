#import "Handle.h"

@protocol IFireEvents <NSObject>

@required
- (void) addEventHandler:(NSString*) eventName handle:(AceHandle*)handle;
- (void) removeEventHandler:(NSString*) eventName;

@end