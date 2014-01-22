#import <Foundation/Foundation.h>
#import "HTTPRequestProvider.h"


@class JSONRequestProvider;


@interface AuthenticatedRequestProvider : NSObject <HTTPRequestProvider>

- (id)initWithAuthToken:(NSString *)token
        requestProvider:(id<HTTPRequestProvider>)requestProvider;

@end
