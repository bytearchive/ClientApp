#import "AuthTokenDeserializer.h"


@implementation AuthTokenDeserializer

#pragma mark - <Deserializer>

- (id)deserialize:(id)foundationCollection
            error:(NSError **)error
{
    NSDictionary *dictionary = (NSDictionary *)foundationCollection;
    return dictionary[@"token"];
}

@end
