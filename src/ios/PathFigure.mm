#import "PathFigure.h"

@implementation PathFigure

- (id) init {
    self = [super init];
    
    // Default property values
    self.Segments = [[PathSegmentCollection alloc] init];
    
    return self;
}

@end
