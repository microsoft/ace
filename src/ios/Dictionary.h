#import <Foundation/Foundation.h>

@interface Dictionary : NSObject
{
    NSMutableDictionary* _dictionary;
}

@property (readonly) unsigned long Count;

- (void)Add:(id)key value:(id)obj;

// For indexing:
- (id)objectForKeyedSubscript:(id <NSCopying>)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

@end