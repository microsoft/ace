//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "CustomActionSheet.h"

@implementation CustomActionSheet

- (void) Show {
    CGRect screen = [UIScreen mainScreen].bounds;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    if (_dismissBackground == nil)
    {
        _dismissBackground = [[UIButton alloc] initWithFrame: [UIScreen mainScreen].bounds];
        [_dismissBackground addSubview:self.Child];
        [_dismissBackground addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    }

    _dismissBackground.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [window.rootViewController.view addSubview:_dismissBackground];

    self.Child.frame = CGRectMake((screen.size.width - self.Child.frame.size.width) / 2, screen.size.height, screen.size.width, self.Child.frame.size.height);

    [UIView animateWithDuration:.3 animations:^{
        self.Child.frame = CGRectMake((screen.size.width - self.Child.frame.size.width) / 2, screen.size.height - self.Child.frame.size.height, screen.size.width, self.Child.frame.size.height);
        _dismissBackground.backgroundColor = [UIColor colorWithWhite:0 alpha:.4];
    } completion:^(BOOL finished) {
    }];

}

- (void)dismiss:(id)sender {
    CGRect screen = [UIScreen mainScreen].bounds;

    [UIView animateWithDuration:.3 animations:^{
        self.Child.frame = CGRectMake((screen.size.width - self.Child.frame.size.width) / 2, screen.size.height, screen.size.width, self.Child.frame.size.height);
        _dismissBackground.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        [_dismissBackground removeFromSuperview];
    }];
}

@end
