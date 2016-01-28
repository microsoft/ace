#import "Button.h"
#import "IconElement.h"

@interface AppBarButton : Button
{
    IconElement* _Icon;
    UIBarButtonItem* _ToolbarItem;
}

@property NSString* Label;
@property IconElement* Icon;
@property UIBarButtonItem* ToolbarItem;

@property bool hasSystemIcon;
@property UIBarButtonSystemItem systemIcon;

@end
