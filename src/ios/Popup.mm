#import "Popup.h"
#import "UIViewHelper.h"
#import "Page.h"
#import "Frame.h"

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
        throw [NSString stringWithFormat:@"Unhandled property for %s: %@", object_getClassName(self), propertyName];
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
		[_content layoutSubviews];
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
    CGRect newFrame = self.frame;
    
    y += [UIApplication sharedApplication].statusBarFrame.size.height;

	if (![Frame getNavigationController].navigationBarHidden) {
		y += 44;
	}

    newFrame.origin.x = x;
    newFrame.origin.y = y;
    
    self.frame = newFrame;
    _isFullScreen = false;
}

- (void) SetX:(int)x andY:(int)y width:(int)width height:(int)height {
	_hasExplicitSize = true;

    CGRect newFrame = self.frame;
    
    newFrame.size.width = width;
    newFrame.size.height = height;
    
    y += [UIApplication sharedApplication].statusBarFrame.size.height;

	if (![Frame getNavigationController].navigationBarHidden) {
		y += 44;
	}

    newFrame.origin.x = x;
    newFrame.origin.y = y;
    
    self.frame = newFrame;
    _isFullScreen = false;
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
    if (_isFullScreen) {
        self.frame = [UIScreen mainScreen].applicationFrame;
		if (![Frame getNavigationController].navigationBarHidden) {
            CGRect r = self.frame;
            self.frame = CGRectMake(r.origin.x, r.origin.y + 44, r.size.width, r.size.height - 44);
		}
	}
	else if (!_hasExplicitSize && _content != nil) {
		// Match the size of the content
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _content.frame.size.width, _content.frame.size.height);
	}
}

@end
