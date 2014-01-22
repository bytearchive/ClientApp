#import "HTTPClient.h"
#import "KSDeferred.h"


@interface HTTPClient ()

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSIndexSet *acceptableStatusCodes;

@end


@implementation HTTPClient

- (id)initWithSession:(NSURLSession *)session
                queue:(NSOperationQueue *)queue
acceptableStatusCodes:(NSIndexSet *)acceptableStatusCodes
{
    self = [super init];
    if (self) {
        self.session = session;
        self.queue = queue;
        self.acceptableStatusCodes = acceptableStatusCodes;
    }
    return self;
}

#pragma mark - <RequestPromiseClient>

- (KSPromise *)promiseWithRequest:(NSURLRequest *)request
{
    KSDeferred *deferred = [KSDeferred defer];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                          __strong typeof(weakSelf) strongSelf = weakSelf;
                                          [strongSelf.queue addOperationWithBlock:^{
                                              if (error) {
                                                  [deferred rejectWithError:error];
                                              }
                                              else if ([self.acceptableStatusCodes containsIndex:httpResponse.statusCode]) {
                                                  [deferred resolveWithValue:data];
                                              }
                                              else {
                                                  NSString *errorDomain = @"com.prairiedogg.clientapp.errors.httpStatusCodeError";
                                                  NSError *httpStatusCodeError = [NSError errorWithDomain:errorDomain
                                                                                                     code:1000
                                                                                                 userInfo:nil];
                                                  [deferred rejectWithError:httpStatusCodeError];
                                              }
                                          }];
                                      }];
    [dataTask resume];
    return deferred.promise;
}

#pragma mark - NSObject

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
