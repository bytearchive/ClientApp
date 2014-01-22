#import <Foundation/Foundation.h>
#import "RequestPromiseClient.h"


@class KSPromise;


@interface JSONClient : NSObject <RequestPromiseClient>

- (id)initWithRequestPromiseClient:(id<RequestPromiseClient>)requestPromiseClient;

@end
