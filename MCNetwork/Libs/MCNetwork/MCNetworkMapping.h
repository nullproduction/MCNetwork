//
// MCNetworkMapping.h
//

#import "NSObject+ValueForKeyPathWithIndexes.h"

@interface MCNetworkMapping : NSObject

+ (NSArray*)convert:(NSDictionary*)object withMapping:(NSDictionary*)mapping;

@end