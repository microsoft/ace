//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "WebView.h"
#import "UIViewHelper.h"

@implementation AceWebView

- (id)init {
    self = [super init];
    self.delegate = self;
    return self;
}

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if (![UIViewHelper setProperty:self propertyName:propertyName propertyValue:propertyValue]) {
        if ([propertyName compare:@"WebView.Source"] == 0) {
            NSString* source = (NSString*)propertyValue;
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:source]];
            [self loadRequest:request];
        }
        else {
            throw [NSString stringWithFormat:@"Unhandled property for %@: %@", [self class], propertyName];
        }
    }
}

- (CGSize) sizeThatFits:(CGSize)size {
    // Choose an arbitrary default size
    return CGSizeMake(300, 500);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return true;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSString* description = error.description;
    throw description;
}

@end
