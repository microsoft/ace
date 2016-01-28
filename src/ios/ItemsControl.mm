#import "ItemsControl.h"
#import "UIViewHelper.h"

@implementation ItemsControl

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if (![UIViewHelper setProperty:self propertyName:propertyName propertyValue:propertyValue]) {
        if ([propertyName compare:@"ItemsControl.Items"] == 0) {
            [self setItems:(ItemCollection*)propertyValue];
        }
        else {
            throw [NSString stringWithFormat:@"Unhandled property for %s: %@", object_getClassName(self), propertyName];
        }
    }
}

- (ItemCollection*)Items {
    return _Items;
}

-(void) setItems:(ItemCollection*)newValue {
    _Items = newValue;
}

@end
