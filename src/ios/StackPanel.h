#import "IHaveProperties.h"
#import "IRecieveCollectionChanges.h"
#import "UIElementCollection.h"

@interface StackPanel : UIView <IHaveProperties, IRecieveCollectionChanges>
{
    BOOL _isVertical;
	UIElementCollection* _children;
    BOOL _autoWidth;
    BOOL _autoHeight;
}
@end
