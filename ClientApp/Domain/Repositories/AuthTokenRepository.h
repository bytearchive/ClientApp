#import <Foundation/Foundation.h>


@class KSPromise;
@class AuthTokenService;


@interface AuthTokenRepository : NSObject

- (id)initWithAuthTokenService:(AuthTokenService *)authTokenService;

- (KSPromise *)tokenPromiseWithUsername:(NSString *)username
                               password:(NSString *)password;

@end