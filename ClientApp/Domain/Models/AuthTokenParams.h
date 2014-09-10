#import "JKVValue.h"


@interface AuthTokenParams : JKVValue

@property (nonatomic, copy, readonly) NSString *username;
@property (nonatomic, copy, readonly) NSString *password;

- (instancetype)init __attribute__((unavailable("Please use initWithUsername:password: when initializing AuthTokenParams")));

- (instancetype)initWithUsername:(NSString *)username
                        password:(NSString *)password;

@end
