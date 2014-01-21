#import <Foundation/Foundation.h>


@protocol Serializer <NSObject>

- (NSDictionary *)dictionaryWithObject:(id)domainObject;

@end
