#import "DatePicker.h"
#import "UIViewHelper.h"
#import "OutgoingMessages.h"

@implementation DatePicker

- (id)init
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    // Default property values
    _date = [NSDate date];
    
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"MMMM d, yyyy"];
    
    _dropDownButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_dropDownButton setTitle:[_formatter stringFromDate:_date] forState:UIControlStateNormal];
    [_dropDownButton addTarget:self action:@selector(OnDropDownOpened:) forControlEvents:UIControlEventTouchUpInside];
    _dropDownButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _dropDownButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    
    [self.contentView addSubview:_dropDownButton];
    
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker addTarget:self action:@selector(dateIsChanged:) forControlEvents:UIControlEventValueChanged];

    return self;
}

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if (![UIViewHelper setProperty:self propertyName:propertyName propertyValue:propertyValue]) {
        // This implementation is shared by TimePicker, hence the suffix checks
        if ([propertyName hasSuffix:@".Header"]) {
            //TODO: Conversion and need to clear subview/text if switching value:
            if ([propertyValue isKindOfClass:[NSString class]])
                self.textLabel.text = (NSString*)propertyValue;
            else if ([propertyValue isKindOfClass:[UIView class]])
                [self addSubview:_Header];
            else
                self.textLabel.text = [propertyValue description];
        }
        else if ([propertyName hasSuffix:@".Date"] || [propertyName hasSuffix:@".Time"]) {
            _date = [_datePicker date];
            [_dropDownButton setTitle:[_formatter stringFromDate:_date] forState:UIControlStateNormal];
        }
        else {
            throw [NSString stringWithFormat:@"Unhandled property for %s: %@", object_getClassName(self), propertyName];
        }
    }
}

// IFireEvents.addEventHandler
- (void) addEventHandler:(NSString*) eventName handle:(AceHandle*)handle {
    if ([eventName compare:@"datechanged"] == 0) {
        if (_dateChangedHandlers == 0) {
            _handle = handle;
        }
        _dateChangedHandlers++;
    }
    else if ([eventName compare:@"timechanged"] == 0) {
        if (_timeChangedHandlers == 0) {
            _handle = handle;
        }
        _timeChangedHandlers++;
    }
}

// IFireEvents.removeEventHandler
- (void) removeEventHandler:(NSString*) eventName {
    if ([eventName compare:@"datechanged"] == 0) {
        _dateChangedHandlers--;
    }
    else if ([eventName compare:@"timechanged"] == 0) {
        _timeChangedHandlers--;
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    // Align the button, using the label as a guide
    CGRect r = self.textLabel.frame;
    
    _dropDownButton.frame = CGRectMake(
                                       r.origin.x + r.size.width,
                                       r.origin.y - (r.size.height / 2),
                                       self.frame.size.width - r.origin.x - r.size.width,
                                       r.size.height * 2);
}

-(void)OnDropDownOpened:(id)sender
{
    if (_sheet == nil)
    {
        _sheet = [[CustomActionSheet alloc] init];
        _sheet.Child = _datePicker;
    }

    _datePicker.date = _date;

    [_sheet Show];
}

- (void)dateIsChanged:(id)sender {
    _date = [_datePicker date];
    [_dropDownButton setTitle:[_formatter stringFromDate:_date] forState:UIControlStateNormal];
    
    if (_dateChangedHandlers > 0) {
        [OutgoingMessages raiseEvent:@"datechanged" handle:_handle eventData:nil];
    }
    if (_timeChangedHandlers > 0) {
        [OutgoingMessages raiseEvent:@"timechanged" handle:_handle eventData:nil];
    }
}

@end