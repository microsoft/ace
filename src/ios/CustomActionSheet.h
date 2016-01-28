#import <UIKit/UIKit.h>

@interface CustomActionSheet : UIView
{
    UIView* _customView;
    UIButton* _dismissBackground;
}

@property UIView* Child;

- (void) Show;
- (void) dismiss:(id)sender;

@end
