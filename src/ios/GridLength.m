#import "GridLength.h"

@implementation GridLength

+ (NSObject*) deserialize:(NSDictionary*)obj {
    GridLength* gl = [[GridLength alloc] init];
    gl->type = [obj[@"type"] intValue];
    gl->gridValue = [obj[@"gridValue"] doubleValue];
    return gl;
}

@end
