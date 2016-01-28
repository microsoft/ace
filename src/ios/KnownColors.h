@interface KnownColors : NSObject

+ (NSString*) ColorStringToKnownColor:(NSString*) colorString;
+ (NSString*) MatchColor:(NSString*) colorString isKnownColor:(bool*) isKnownColor isNumericColor:(bool*) isNumericColor isContextColor:(bool*) isContextColor isScRgbColor:(bool*) isScRgbColor;

@end
