#import <Foundation/Foundation.h>


@class KSPromise;
@class JSONRequestProvider;
@class DomainObjectClient;
@protocol Deserializer;
@protocol HTTPRequestProvider;


@interface AuthTokenService : NSObject

- (id)initWithRequestProvider:(id<HTTPRequestProvider>)requestProvider
           domainObjectClient:(DomainObjectClient *)domainObjectClient
                 deserializer:(id<Deserializer>)deserializer;

- (KSPromise *)tokenPromiseWithUsername:(NSString *)username
                               password:(NSString *)password;

@end