#import "WebView.h"
#import "UIViewHelper.h"

@implementation AceWebView

- (id)init {
    self = [super init];
    self.delegate = self;
    self.frame = CGRectMake(0, 0, 300.0, 500.0); // TODO: Default size
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
            throw [NSString stringWithFormat:@"Unhandled property for %s: %@", object_getClassName(self), propertyName];
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return true;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    throw error.description;
}


@end
