@interface AceViewController : UIViewController

@property UIView* content;

- (id)initWithContent:(UIView*)view navigationController:(UINavigationController*)navigationController;

@end