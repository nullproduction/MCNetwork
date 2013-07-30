//
//  MCRequestOperation.h
//

#import "SHXMLParser.h"

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

typedef void(^SuccessBlock)(MCRequestOperation *requestOperation);
typedef void(^FailureBlock)(NSError *error);

@property (nonatomic, retain) NSURL *URL;
@property (nonatomic, retain) NSString *URLString;
@property (nonatomic, retain) NSData *responseData;
@property (nonatomic, retain) NSString *responseString;
@property (nonatomic, retain) NSDictionary *responseDictionary;
@property (nonatomic, readwrite) Type type;
@property (nonatomic, copy) SuccessBlock success;
@property (nonatomic, copy) FailureBlock failure;

@end
