//
//  MINetworkConfigurationManager.h
//  MINetWorking
//
//  Created by houxq on 2017/5/27.
//  Copyright © 2017年 MI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MINetworkConfigurationManager : NSObject

+ (instancetype)sharedInstance;



@property (nonatomic, assign) BOOL serviceIsOnline;
@property (nonatomic, assign) NSTimeInterval timeOutSeconds;


@property (nonatomic, assign, readonly) BOOL isReachable;
@end
