#import <Foundation/Foundation.h>


@class KSPromise;
@protocol RequestPromiseClient;
@protocol Deserializer;


@interface DomainObjectClient : NSObject

- (id)initWithRequestPromiseClient:(id<RequestPromiseClient>)requestPromiseClient;

- (KSPromise *)promiseWithRequest:(NSURLRequest *)request
                     deserializer:(id<Deserializer>)deserializer;

@end
