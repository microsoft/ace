#import "IHaveProperties.h"
#import "IFireEvents.h"
#import "Handle.h"

@interface ToggleSwitch : UIView <IHaveProperties, IFireEvents>
{
    UILabel* _header;
    UISwitch* _switch;
    
    int _isOnChangedHandlers;
    AceHandle* _handle;
}
@end
