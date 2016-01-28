#import "StaticResource.h"

@implementation StaticResource

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if ([propertyName compare:@"StaticResource.ResourceKey"] == 0) {
        // Ignore. This is handled on the managed side.
    }
    else {
        throw [NSString stringWithFormat:@"Unhandled property for %s: %@", object_getClassName(self), propertyName];
    }
}

@end
