#import "Setter.h"

@implementation Setter

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if ([propertyName hasSuffix:@".Property"] || [propertyName hasSuffix:@".Value"]) {
        // Ignore. These are handled on the managed side.
    }
    else {
        throw [NSString stringWithFormat:@"Unhandled property for %s: %@", object_getClassName(self), propertyName];
    }
}

@end
