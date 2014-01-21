#import <Foundation/Foundation.h>


@class KSPromise;
@class RequestProvider;
@class DomainObjectClient;
@protocol Deserializer;


@interface AuthTokenService : NSObject

- (id)initWithRequestProvider:(RequestProvider *)requestProvider
           domainObjectClient:(DomainObjectClient *)domainObjectClient
                 deserializer:(id<Deserializer>)deserializer;

- (KSPromise *)tokenPromiseWithUsername:(NSString *)username
                               password:(NSString *)password;

@end