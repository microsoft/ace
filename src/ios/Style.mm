#import "Style.h"

@implementation XamlStyle

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if ([propertyName compare:@"Style.TargetType"] == 0 || [propertyName compare:@"Style.Setters"] == 0) {
        // Ignore. These are handled on the managed side.
    }
    else {
        throw [NSString stringWithFormat:@"Unhandled property for %s: %@", object_getClassName(self), propertyName];
    }
}

@end
