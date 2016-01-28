#import "TextBlock.h"
#import "UILabelHelper.h"

@implementation TextBlock

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {    
    if (![UILabelHelper setProperty:self propertyName:propertyName propertyValue:propertyValue]) {
        throw [NSString stringWithFormat:@"Unhandled property for %s: %@", object_getClassName(self), propertyName];
    }
}

@end
