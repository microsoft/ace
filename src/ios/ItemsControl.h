#import "ItemCollection.h"
#import "IHaveProperties.h"

@interface ItemsControl : UIView<IHaveProperties, UIPickerViewDelegate>
{
    ItemCollection* _Items;
}

@property ItemCollection* Items;

@end
