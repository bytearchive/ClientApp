#import <Foundation/Foundation.h>


@protocol Deserializer <NSObject>

-(id)deserialize:(id)foundationCollection error:(NSError **)error;

@end
