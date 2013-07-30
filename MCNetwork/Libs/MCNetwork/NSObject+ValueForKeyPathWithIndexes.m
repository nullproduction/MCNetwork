//
//  NSObject+ValueForKeyPathWithIndexes.m
//

#import "NSObject+ValueForKeyPathWithIndexes.h"


@implementation NSObject(ValueForKeyPathWithIndexes)

/*
 * Value for KeyPath With Indexes
 */
- (id)valueForKeyPathWithIndexes:(NSString*)fullPath
{
    NSRange testrange = [fullPath rangeOfString:@"["];
    if (testrange.location == NSNotFound)
        return [self valueForKeyPath:fullPath];
    
    NSArray* parts = [fullPath componentsSeparatedByString:@"."];
    id currentObj = self;
    for (NSString* part in parts)
    {
        NSRange range1 = [part rangeOfString:@"["];
        if (range1.location == NSNotFound)
        {
            currentObj = [currentObj valueForKey:part];
        }
        else
        {
            NSString* arrayKey = [part substringToIndex:range1.location];
            int index = [[[part substringToIndex:part.length-1] substringFromIndex:range1.location+1] intValue];
            currentObj = [[currentObj valueForKey:arrayKey] objectAtIndex:index];
        }
    }
    return currentObj;
}

@end
