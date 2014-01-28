#import "HTTPClient.h"
#import "KSDeferred.h"
#import "HTTPClientDelegate.h"


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

- (KSPromise *)promiseWithRequest:(NSURLRequest *)request
{
    KSDeferred *deferred = [KSDeferred defer];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          __strong typeof(weakSelf) strongSelf = weakSelf;

                                          void(^requestCompleteBlock)(NSArray *, NSArray *, NSArray *);
                                          requestCompleteBlock = ^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
                                              [strongSelf.delegate httpClient:strongSelf didUpdateTaskCount:dataTasks.count];
                                          };

                                          [strongSelf.session getTasksWithCompletionHandler:requestCompleteBlock];
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

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
    [self.delegate httpClient:self didSendRequest:request];
    return deferred.promise;
}

@end
