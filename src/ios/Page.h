#import "IHaveProperties.h"
#import "CommandBar.h"

@interface Page : UIView <IHaveProperties>
{
    CommandBar* _topAppBar;    
    NSObject* _bottomAppBar;    
    UIView* _content;
}

@property NSString* frameTitle;

- (NSObject*)getBottomAppBar;
- (CommandBar*)getTopAppBar;

@end
