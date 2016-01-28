#import "TimePicker.h"

@implementation TimePicker

-(id) init {
    self = [super init];
    
    _datePicker.datePickerMode = UIDatePickerModeTime;
    [_formatter setDateFormat:@"h:mm a"];
    [_dropDownButton setTitle:[_formatter stringFromDate:_date] forState:UIControlStateNormal];

    return self;
}

@end
