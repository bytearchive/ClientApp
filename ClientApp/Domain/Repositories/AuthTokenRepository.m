#import "AuthTokenRepository.h"
#import "KSPromise.h"
#import "AuthTokenService.h"


@interface AuthTokenRepository ()

@property(strong, nonatomic) AuthTokenService *authTokenService;

@end


@implementation AuthTokenRepository

- (id)initWithAuthTokenService:(AuthTokenService *)authTokenService
{
    self = [super init];
    if (self) {
        self.authTokenService = authTokenService;
    }
    return self;
}

- (KSPromise *)tokenPromiseWithUsername:(NSString *)username
                               password:(NSString *)password
{
    return [self.authTokenService tokenPromiseWithUsername:username password:password];
}

#pragma mark - NSObject

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
    
}

@end