#import "GridLength.h"
#import "IHaveProperties.h"

@interface ColumnDefinition : NSObject <IHaveProperties>
{
@public
    GridLength* width;    
    double calculatedWidth;
    double calculatedLeft;
}

@end
