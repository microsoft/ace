#import "IHaveProperties.h"

@interface Popup : UIView <IHaveProperties>
{
    UIView* _content;
    BOOL _isFullScreen;
	BOOL _hasExplicitSize;
}

+ (void) CloseAll;

@end
