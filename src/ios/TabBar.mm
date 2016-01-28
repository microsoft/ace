#import "TabBar.h"
#import "UIViewHelper.h"
#import "OutgoingMessages.h"

@implementation TabBar

- (id) init {
    self = [super init];
    self.delegate = self;
    return self;
}

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if (![UIViewHelper setProperty:self propertyName:propertyName propertyValue:propertyValue]) {
        if ([propertyName hasSuffix:@".PrimaryCommands"] ||
            [propertyName hasSuffix:@".Children"]) {
            if (propertyValue == nil) {
                [items removeListener:self];
                items = nil;
            }
            else {
                items = (CommandBarElementCollection*)propertyValue;
                // Listen to collection changes
                [items addListener:self];
            }
        }
        else {
            throw [NSString stringWithFormat:@"Unhandled property for %s: %@", object_getClassName(self), propertyName];
        }
    }
}

// IRecieveCollectionChanges.add
- (void) add:(NSObject*)collection item:(NSObject*)item {
    //assert collection == items;
    // TODO: Update items
}

// IRecieveCollectionChanges.removeAt
- (void) removeAt:(NSObject*)collection index:(int)index {
    //assert collection == items;
    // TODO: Update items
}

- (void)tabBar:(UITabBar*)tabBar didSelectItem:(UITabBarItem*)item {
    int index = item.tag;    
    [OutgoingMessages raiseEvent:@"click" instance:items[index] eventData:nil];
}

@end
