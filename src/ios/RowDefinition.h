#import "GridLength.h"
#import "IHaveProperties.h"

@interface RowDefinition : NSObject <IHaveProperties>
{
@public
    GridLength* height;    
    double calculatedHeight;
    double calculatedTop;
}

@end
