#import "IHaveProperties.h"
#import "IRecieveCollectionChanges.h"
#import "UIElementCollection.h"

@interface Canvas : UIView <IHaveProperties, IRecieveCollectionChanges>
{
	UIElementCollection* _children;
}
@end
