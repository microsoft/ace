//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Popup.h"
#import "UIViewHelper.h"
#import "Page.h"
#import "Frame.h"
#import "RectUtils.h"

@implementation Popup

NSMutableArray* _visiblePopups;

- (id)init {
    self = [super init];

    // Fullscreen by default
    _isFullScreen = true;
	_hasExplicitSize = false;

    return self;
}

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if (![UIViewHelper setProperty:self propertyName:propertyName propertyValue:propertyValue]) {
        throw [NSString stringWithFormat:@"Unhandled property for %@: %@", [self class], propertyName];
    }

    // Extra logic for content property
    if ([propertyName hasSuffix:@".Content"] && propertyValue != nil) {
        // Used elsewhere
        _content = (UIView*)propertyValue;
    }
}

- (void) Show {
    UIViewController* viewController = [Frame getNavigationController].topViewController;

    [viewController.view addSubview:self];

    if (_isFullScreen && _content != nil && [_content isKindOfClass:[Page class]]) {
        Page* p = (Page*)_content;
        if (p.frameTitle != nil) {
            [Frame ShowNavigationBar];
            [viewController setTitle:p.frameTitle];
        }
        //TODO: App bar, too
    }

    if (_visiblePopups == nil) {
        _visiblePopups = [[NSMutableArray alloc] init];
    }
    [_visiblePopups addObject:self];

	if (!_hasExplicitSize && _content != nil) {
		// Auto-size
		[self layoutSubviews];
	}
}

- (void) Hide {
    [self removeFromSuperview];
    if (_visiblePopups != nil) {
        [_visiblePopups removeObject:self];
    }

    if (_content != nil && [_content isKindOfClass:[Page class]] && ((Page*)_content).frameTitle != nil) {
        [Frame HideNavigationBar];
    }
}

- (void) SetX:(int)x andY:(int)y {
    _explicitX = x;
    _explicitY = y;
    _isFullScreen = false;

    [self positionPopup];
}

- (void) SetX:(int)x andY:(int)y width:(int)width height:(int)height {
    _explicitX = x;
    _explicitY = y;
    _explicitWidth = width;
    _explicitHeight = height;
    _isFullScreen = false;
	_hasExplicitSize = true;
    
    [self positionPopup];
}

+ (void) CloseAll {
    if (_visiblePopups != nil) {
        for (int i = 0; i < _visiblePopups.count; i++) {
            //TODO: Also destroy
            [(Popup*)_visiblePopups[i] Hide];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self positionPopup];
}

- (void)positionPopup {
    // Adjust for the navigation bar, if present
    CGFloat navBarHeight = 0;
    if (![Frame getNavigationController].navigationBarHidden) {
        navBarHeight = [Frame getNavigationController].navigationBar.frame.size.height;
    }

    if (_isFullScreen) {
        // Occupy the entire application frame, but adjust for the navigation bar
        CGRect r = [UIScreen mainScreen].applicationFrame;
        self.frame = CGRectMake(r.origin.x, r.origin.y + navBarHeight, r.size.width, r.size.height - navBarHeight);
        if (_content != nil) {
            _content.frame = [RectUtils replace:_content.frame size:self.frame.size];
        }
	}
	else {
        // Start with the entire application frame, but adjust for the navigation bar
        CGRect r = [UIScreen mainScreen].applicationFrame;
        r = CGRectMake(r.origin.x, r.origin.y + navBarHeight, r.size.width, r.size.height - navBarHeight);
        
        // Add the explicit position to this adjusted rectangle
        r = CGRectMake(r.origin.x + _explicitX, r.origin.y + _explicitY, r.size.width, r.size.height);
        
        if (_hasExplicitSize) {
            // Apply the specified size
            r = CGRectMake(r.origin.x, r.origin.y, _explicitWidth, _explicitHeight);
            if (_content != nil) {
                _content.frame = [RectUtils replace:_content.frame size:r.size];
            }
        }
        else if (_content != nil) {
            // Match the size of the content
            r = CGRectMake(r.origin.x, r.origin.y, _content.frame.size.width, _content.frame.size.height);            
        }
        
        self.frame = r;
    }
}

@end
