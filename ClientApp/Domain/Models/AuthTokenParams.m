#import "AuthTokenParams.h"


@interface AuthTokenParams ()

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@end


@implementation AuthTokenParams

- (instancetype)initWithUsername:(NSString *)username
                        password:(NSString *)password
{
    self = [super init];
    if (self) {
        self.username = username;
        self.password = password;
    }
    return self;
}

#pragma mark - NSObject

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
