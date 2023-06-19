#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import "React/RCTEventEmitter.h"

@interface RCT_EXTERN_MODULE(LocalSearchManager, RCTEventEmitter)
RCT_EXTERN_METHOD(searchLocations:(NSString *)text)
RCT_EXTERN_METHOD(searchCoodinate:(NSString *)query resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
@end


