#import "IHaveProperties.h"
#import "IRecieveCollectionChanges.h"
#import "CommandBarElementCollection.h"

@interface TabBar : UITabBar <UITabBarDelegate, IHaveProperties, IRecieveCollectionChanges>
{
    @public
	CommandBarElementCollection* items;
}
@end
