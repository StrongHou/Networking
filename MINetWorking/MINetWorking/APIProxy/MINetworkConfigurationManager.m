//
//  MINetworkConfigurationManager.m
//  MINetWorking
//
//  Created by houxq on 2017/5/27.
//  Copyright © 2017年 MI. All rights reserved.
//

#import "MINetworkConfigurationManager.h"
#import <AFNetworking.h>

@implementation MINetworkConfigurationManager

static MINetworkConfigurationManager *sharedInstance_;

+ (instancetype)sharedInstance
{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance_ = [[self alloc] init];
 
        sharedInstance_.serviceIsOnline = NO;
        sharedInstance_.timeOutSeconds = 20.0f;
       
      
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return sharedInstance_;
}


- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

@end
