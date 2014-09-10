#import "AuthTokenDeserializer.h"


@implementation AuthTokenDeserializer

#pragma mark - <PDDeserializer>

- (id)deserialize:(id)foundationCollection error:(NSError *__autoreleasing *)error
{
    NSDictionary *dictionary = (NSDictionary *)foundationCollection;
    return dictionary[@"token"];
}

@end
