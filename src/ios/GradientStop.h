#import "IHaveProperties.h"

@interface GradientStop : NSObject <IHaveProperties>

@property UIColor* color;
@property double offset;

@end
