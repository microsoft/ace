enum GridUnitType { GridUnitTypeAuto, GridUnitTypePixel, GridUnitTypeStar };

@interface GridLength : NSObject
{
@public
	int type;
	double gridValue;
}

+ (NSObject*) deserialize:(NSDictionary*)obj;

@end
