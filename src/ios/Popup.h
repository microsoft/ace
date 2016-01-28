#import "IHaveProperties.h"

@interface Popup : UIView <IHaveProperties>
{
    UIView* _content;
    BOOL _isFullScreen;
}

+ (void) CloseAll;

@end
