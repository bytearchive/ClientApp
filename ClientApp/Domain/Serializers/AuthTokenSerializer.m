#import "AuthTokenSerializer.h"
#import "AuthTokenParams.h"


@implementation AuthTokenSerializer

- (id)serialize:(id)requestParameters error:(NSError *__autoreleasing *)error
{
    AuthTokenParams *authTokenParams = requestParameters;
    return @{@"username": authTokenParams.username,
             @"password": authTokenParams.password};
}

@end
