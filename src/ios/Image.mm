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

            // Set to natural image size by default
            NSNumber* w = [self.layer valueForKey:@"Ace.Width"];
            NSNumber* h = [self.layer valueForKey:@"Ace.Height"];
            if (w == nil) {
                self.frame = [RectUtils replace:self.frame width:self.image.size.width * self.image.scale];
            }
            if (h == nil) {
                self.frame = [RectUtils replace:self.frame height:self.image.size.height * self.image.scale];
            }
        }
    }
}

@end
