#import "ListBoxItem.h"
#import "UIViewHelper.h"

@implementation ListBoxItem

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if ([propertyName hasSuffix:@".Content"]) {
        _Content = propertyValue;
    }
    else {
        throw [NSString stringWithFormat:@"Unhandled property for %s: %@", object_getClassName(self), propertyName];
    }
}

@end
