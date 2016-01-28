#import "Canvas.h"
#import "UIViewHelper.h"

@implementation Canvas

- (id)init {
    self = [super init];

    // TODO: infinite size so input events travel to children
    self.frame = [UIScreen mainScreen].bounds;

    return self;
}

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if (![UIViewHelper setProperty:self propertyName:propertyName propertyValue:propertyValue]) {
        if ([propertyName compare:@"Panel.Children"] == 0) {
            if (propertyValue == nil) {
                [_children removeListener:self];
                _children = nil;
            }
            else {
                _children = (UIElementCollection*)propertyValue;
                // Listen to collection changes
                [_children addListener:self];
            }
        }
        else {
            throw [NSString stringWithFormat:@"Unhandled property for %s: %@", object_getClassName(self), propertyName];
        }
    }
}

// IRecieveCollectionChanges.add
- (void) add:(NSObject*)collection item:(NSObject*)item {
    //assert collection == _children;
    [self addSubview:(UIView*)item];
}

// IRecieveCollectionChanges.removeAt
- (void) removeAt:(NSObject*)collection index:(int)index {
    //assert collection == _children;
    UIView* view = [self subviews][index];
    [view removeFromSuperview];
}

@end
