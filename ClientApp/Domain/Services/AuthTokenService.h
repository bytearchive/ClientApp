#import <Foundation/Foundation.h>


@class KSPromise;
@class JSONRequestProvider;
@class DomainObjectClient;
@protocol Deserializer;


@interface AuthTokenService : NSObject

- (id)initWithRequestProvider:(JSONRequestProvider *)requestProvider
           domainObjectClient:(DomainObjectClient *)domainObjectClient
                 deserializer:(id<Deserializer>)deserializer;

- (KSPromise *)tokenPromiseWithUsername:(NSString *)username
                               password:(NSString *)password;

@end