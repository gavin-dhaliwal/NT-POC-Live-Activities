//
//  TImerWidgetBridge.m
//  FancyTimer
//
//  Created by Raúl Gómez Acuña on 10/01/2024.
//

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(TimerWidgetModule, NSObject)

+ (bool)requiresMainQueueSetup {
  return NO;
}

RCT_EXTERN_METHOD(startLiveActivity)
RCT_EXTERN_METHOD(stopLiveActivity)
RCT_EXTERN_METHOD(observePushToStartToken:(NSString *)consumerId)
RCT_EXTERN_METHOD(getPushToStartToken:(NSString *)consumerId)
RCT_EXTERN_METHOD(observeActivityPushToken)

@end
