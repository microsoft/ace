//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Image.h"
#import "ImageSource.h"
#import "UIViewHelper.h"
#import "Utils.h"
#import "RectUtils.h"

@implementation Image

- (id)init {
    self = [super init];

    // Default behavior
    self.contentMode = UIViewContentModeScaleAspectFit;
    
    return self;
}

- (CGSize) sizeThatFits:(CGSize)size {
    // Set to natural image size by default
    CGFloat width = self.image == nil ? 0 : self.image.size.width * self.image.scale;
    CGFloat height = self.image == nil ? 0 : self.image.size.height * self.image.scale;
    return CGSizeMake(width, height);
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
            else {
                throw [NSString stringWithFormat:@"Invalid type for Image.Source: %@", [propertyValue class]];
            }
            // A source change could change this element's size
            [UIViewHelper resize:self];
        }
    }
}

@end
