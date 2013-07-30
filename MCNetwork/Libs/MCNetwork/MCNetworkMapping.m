//
//  MCNetworkMapping.m
//

#import "MCNetworkMapping.h"

@implementation MCNetworkMapping


/*
 * Convert
 */
+ (NSArray*)convert:(NSDictionary*)object withMapping:(NSDictionary*)mapping
{
    NSArray *array;
    NSMutableArray *newArray = [NSMutableArray array];
    array = [object valueForKeyPathWithIndexes:mapping[@"path"]];
    
    
    for (int i=0; i<array.count; i++)
    {
        NSMutableDictionary *newItem = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *item;
        
        item = array[i];

        NSDictionary *attributes = mapping[@"attributes"];
        
        NSArray *keys = [attributes allKeys];
        
        for (NSString *key in keys)
        {
            NSDictionary *attribute = attributes[key];
            id value = [item valueForKeyPathWithIndexes:attribute[@"path"]];
            if (value)
            {
                // Handler
                if(attribute[@"handler"][@"class"] && attribute[@"handler"][@"method"])
                {
                    value = [self handlerClass:attribute[@"handler"][@"class"] method:attribute[@"handler"][@"method"] arg:value];
                }
                
                // Insert
                [newItem setValue:value forKey:key];
            }
        }
        
        [newArray insertObject:newItem atIndex:newArray.count];
    }
    
    return newArray;
}


/*
 * Handler
 */
+ (id)handlerClass:(NSString *)class method:(NSString *)method arg:(id)arg
{
    __unsafe_unretained id result;
    SEL selector = NSSelectorFromString(method);
    NSMethodSignature* signature = [NSClassFromString(class) methodSignatureForSelector: selector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature: signature];
    [invocation setSelector:selector];
    [invocation setTarget:NSClassFromString(class)];
    [invocation setArgument:&arg atIndex:2];
    [invocation invoke];
    [invocation getReturnValue:&result];
    return result;
}

@end
