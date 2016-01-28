#import "Handle.h"

@interface NativeEventAttacher : NSObject
{
    UIControl* _instance;
    NSString* _event;
}

- (id)initWithInstance:(UIControl*)instance event:(NSString*)eventName;

@end
