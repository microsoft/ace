@interface Frame : UIView

+ (UINavigationController*)getNavigationController;
+ (void)goForward:(UIView*)view;
+ (void)GoBack;
+ (void)ShowNavigationBar;
+ (void)HideNavigationBar;

@end
