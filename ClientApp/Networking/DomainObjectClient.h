#import <Foundation/Foundation.h>


@class JSONClient;
@class KSPromise;
@protocol Deserializer;


@interface DomainObjectClient : NSObject

- (id)initWithJSONClient:(JSONClient *)jsonClient;

- (KSPromise *)promiseWithRequest:(NSURLRequest *)request
                     deserializer:(id<Deserializer>)deserializer;

@end
