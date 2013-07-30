//
//  MCRequestOperation.h
//

#import "SHXMLParser.h"
#import "MCNetworkMapping.h"

@interface MCRequestOperation : NSObject

typedef enum Type
{
    MCNetworkJSON=1,
    MCNetworkXML=2,
    MCNetworkSaveFile=3
}
Type;

+ (MCRequestOperation *)initWithURLString: (NSString *)URLString;
- (void)sendSync;
- (void)sendAsync;

typedef void(^MCNetworkSuccessBlock)(MCRequestOperation *requestOperation);
typedef void(^MCNetworkFailureBlock)(NSError *error);

@property (nonatomic, retain) NSURL *URL;
@property (nonatomic, retain) NSString *URLString;
@property (nonatomic, retain) NSData *responseData;
@property (nonatomic, retain) NSString *responseString;
@property (nonatomic, retain) NSDictionary *responseDictionary;
@property (nonatomic, retain) NSArray *responseDictionaryConvert;
@property (nonatomic, retain) NSDictionary *mapping;
@property (nonatomic, readwrite) Type type;
@property (nonatomic, copy) MCNetworkSuccessBlock success;
@property (nonatomic, copy) MCNetworkFailureBlock failure;

@end
