#import "IHaveProperties.h"

enum TextAlignment { TextAlignmentCenter, TextAlignmentLeft, TextAlignmentRight, TextAlignmentJustify };

@interface TextBlock : UILabel <IHaveProperties>
@end
