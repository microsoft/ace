#import "IHaveProperties.h"
#import "IFireEvents.h"
#import "Handle.h"

@interface Button : UIButton <IHaveProperties, IFireEvents>
{
    int _clickHandlers;
    AceHandle* _handle;
}
@end
