#import "ToggleSwitch.h"
#import "UIViewHelper.h"
#import "OutgoingMessages.h"

@implementation ToggleSwitch

- (id)init {
    self = [super init];

    _header = [[UILabel alloc] init];
    _switch = [[UISwitch alloc] init];

    [self addSubview:_header];
    [self addSubview:_switch];
    
    // Initialize this wrapping view to the size of the switch
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _switch.frame.size.width, _switch.frame.size.height);

    // Touches on the header should toggle the switch
    _header.userInteractionEnabled = true;
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeaderTouch:)];
    [_header addGestureRecognizer:gesture];    

    return self;
}

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if (![UIViewHelper setProperty:self propertyName:propertyName propertyValue:propertyValue]) {
        if ([propertyName compare:@"ToggleSwitch.IsOn"] == 0) {
            [_switch setOn:[(NSNumber*)propertyValue boolValue] animated:true];
        }
        else if ([propertyName hasSuffix:@".Header"]) {
            if ([propertyValue isKindOfClass:[NSString class]] || propertyValue == nil) {
                _header.text = (NSString*)propertyValue;
            }
            else {
                _header.text = [propertyValue description];
            }
        }
        else {
            throw [NSString stringWithFormat:@"Unhandled property for %s: %@", object_getClassName(self), propertyName];
        }
    }
}

- (void)onHeaderTouch:(id)sender {
    [_switch setOn:!_switch.on animated:true];
}

- (void)onIsOnChanged:(id)sender {
    [OutgoingMessages raiseEvent:@"isonchanged" handle:_handle eventData:[NSNumber numberWithBool:_switch.on]];
}

// IFireEvents.addEventHandler
- (void) addEventHandler:(NSString*) eventName handle:(AceHandle*)handle {
    if ([eventName compare:@"isonchanged"] == 0) {
        if (_isOnChangedHandlers == 0) {
            // Set up the message sending, which goes to all handlers
            _handle = handle;
            [_switch addTarget:self action:@selector(onIsOnChanged:) forControlEvents:UIControlEventValueChanged];
        }
        _isOnChangedHandlers++;
    }
}

// IFireEvents.removeEventHandler
- (void) removeEventHandler:(NSString*) eventName {
    if ([eventName compare:@"isonchanged"] == 0) {
        _isOnChangedHandlers--;
        if (_isOnChangedHandlers == 0) {
            // Stop sending messages because nobody is listening
            [_switch removeTarget:self action:@selector(onIsOnChanged:) forControlEvents:UIControlEventValueChanged];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    #define LEFTMARGIN 20
    #define RIGHTMARGIN 20
    
    if (_header.text == nil) {
        // Whatever size was given to this this wrapping view should be given entirely to the switch
        _switch.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    else {
        // Do the normal header + switch layout
        _switch.frame = CGRectMake(self.frame.size.width - _switch.frame.size.width - RIGHTMARGIN,
                                   (self.frame.size.height - _switch.frame.size.height) / 2,
                                   _switch.frame.size.width, _switch.frame.size.height);
                               
        _header.frame = CGRectMake(LEFTMARGIN, 0, self.frame.size.width - LEFTMARGIN, self.frame.size.height);
    }
}

@end
