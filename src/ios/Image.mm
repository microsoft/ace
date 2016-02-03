#import "Image.h"
#import "ImageSource.h"
#import "UIViewHelper.h"
#import "Utils.h"

@implementation Image

- (id)init {
    self = [super init];

    // Default behavior
    self.contentMode = UIViewContentModeScaleAspectFit;

    return self;
}

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if (![UIViewHelper setProperty:self propertyName:propertyName propertyValue:propertyValue]) {
        if ([propertyName hasSuffix:@".Source"]) {
            if ([propertyValue isKindOfClass:[NSString class]]) {
                self.image = [Utils getImage:(NSString*)propertyValue];
            }
            else if ([propertyValue isKindOfClass:[ImageSource class]]) {
                self.image = [Utils getImage:((ImageSource*)propertyValue).UriSource];
            }
        }
    }
}

@end
