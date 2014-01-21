#import "DomainObjectClient.h"
#import "JSONClient.h"
#import "KSDeferred.h"
#import "Deserializer.h"


@interface DomainObjectClient ()

@property (strong, nonatomic) JSONClient *jsonClient;

@end


@implementation DomainObjectClient

- (id)initWithJSONClient:(JSONClient *)jsonClient
{
    self = [super init];
    if (self) {
        self.jsonClient = jsonClient;
    }
    return self;
}

- (KSPromise *)promiseWithRequest:(NSURLRequest *)request
                     deserializer:(id<Deserializer>)deserializer
{
    KSDeferred *deferred = [KSDeferred defer];
    KSPromise *foundationCollectionPromise = [self.jsonClient promiseWithRequest:request];
    [foundationCollectionPromise then:^id(id foundationCollection) {
        NSError *error = nil;
        id domainObject = [deserializer deserialize:foundationCollection error:&error];
        if (domainObject || !error) {
            [deferred resolveWithValue:domainObject];
        }
        else
        {
            [deferred rejectWithError:error];
        }
        return foundationCollection;
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
