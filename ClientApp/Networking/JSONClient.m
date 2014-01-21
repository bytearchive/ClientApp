#import "JSONClient.h"
#import "HTTPClient.h"
#import "KSDeferred.h"


@interface JSONClient ()

@property (strong, nonatomic) HTTPClient *httpClient;

@end


@implementation JSONClient

- (id)initWithHTTPClient:(HTTPClient *)httpClient
{
    self = [super init];
    if (self) {
        self.httpClient = httpClient;
    }
    return self;
}

- (KSPromise *)promiseWithRequest:(NSURLRequest *)request
{
    KSDeferred *deferred = [KSDeferred defer];
    KSPromise *dataPromise = [self.httpClient promiseWithRequest:request];
    [dataPromise then:^id(NSData *responseData) {
        NSError *error;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        if (responseData && responseData.length > 0 && !jsonObject && error) {
            NSString *errorDomainString = @"com.prairiedogg.reservations.errors.jsonDeserializationError";
            NSError *error = [NSError errorWithDomain:errorDomainString code:1001 userInfo:nil];
            [deferred rejectWithError:error];
        }
        else {
            [deferred resolveWithValue:jsonObject];
        }
        return responseData;
    }
                error:^id(NSError *error) {
                    [deferred rejectWithError:error];
                    return error;
                }];
    
    return deferred.promise;
}

#pragma mark - NSObject

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
