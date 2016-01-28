#import "IHaveProperties.h"
#import "CommandBarElementCollection.h"

@interface CommandBar : NSObject <IHaveProperties>
{
    CommandBarElementCollection* _primaryCommands;
    CommandBarElementCollection* _secondaryCommands;
}

- (CommandBarElementCollection*) getPrimaryCommands;
- (CommandBarElementCollection*) getSecondaryCommands;

+ (void)showNavigationBar:(CommandBar*)bar on:(UIViewController*)viewController animated:(BOOL)animated;
+ (void)showTabBar:(NSObject*)bar on:(UIViewController*)viewController animated:(BOOL)animated;

@end
