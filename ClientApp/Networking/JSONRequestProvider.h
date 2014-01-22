#import <Foundation/Foundation.h>
#import "HTTPRequestProvider.h"


@interface JSONRequestProvider : NSObject <HTTPRequestProvider>

- (id)initWithURLComponents:(NSURLComponents *)urlComponents;

@end