#import "AuthTokenService.h"
#import "KSPromise.h"
#import "RequestProvider.h"
#import "DomainObjectClient.h"
#import "Deserializer.h"


@interface AuthTokenService ()

@property (strong, nonatomic) RequestProvider *requestProvider;
@property (strong, nonatomic) DomainObjectClient *domainObjectClient;
@property (strong, nonatomic) id<Deserializer> deserializer;

@end


@implementation AuthTokenService

- (id)initWithRequestProvider:(RequestProvider *)requestProvider
           domainObjectClient:(DomainObjectClient *)domainObjectClient
                 deserializer:(id<Deserializer>)deserializer
{
    self = [super init];
    if (self) {
        self.requestProvider = requestProvider;
        self.domainObjectClient = domainObjectClient;
        self.deserializer = deserializer;
    }
    return self;
}

- (KSPromise *)tokenPromiseWithUsername:(NSString *)username 
                               password:(NSString *)password 
{
    NSDictionary *params = @{
            @"username": username,
            @"password": password,
    };

    NSURLRequest *request = [self.requestProvider postRequestWithPath:@"/api/auth/token/"
                                                               params:params];
    return [self.domainObjectClient promiseWithRequest:request deserializer:self.deserializer];
    
}


#pragma mark - NSObject 

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end