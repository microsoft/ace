#import "ColumnDefinition.h"
#import "GridLengthConverter.h"

@implementation ColumnDefinition

-(id) init {
    self = [super init];
    
    // Set default to *
    self->width = [[GridLength alloc] init];
    self->width->gridValue = 1;
    self->width->type = GridUnitTypeStar;
    
    return self;
}

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if ([propertyName compare:@"ColumnDefinition.Width"] == 0) {
        if ([propertyValue isKindOfClass:[GridLength class]])
            self->width = (GridLength*)propertyValue;
        else
            self->width = [GridLengthConverter parse:(NSString*)propertyValue];
    }
    else {
        throw [NSString stringWithFormat:@"Unhandled property for %s: %@", object_getClassName(self), propertyName];
    }
}

@end
