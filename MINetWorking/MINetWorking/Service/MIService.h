//
//  MIService.h
//  MINetWorking
//
//  Created by houxq on 2017/5/25.
//  Copyright © 2017年 MI. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MIURLResponse;

@protocol MIServiceProtocol <NSObject>

@required

@property (nonatomic, readonly) BOOL isOnline;

@property (nonatomic, readonly) NSString *offlineApiBaseUrl;
@property (nonatomic, readonly) NSString *onlineApiBaseUrl;

@property (nonatomic, readonly) NSString *offlineApiVersion;
@property (nonatomic, readonly) NSString *onlineApiVersion;

@property (nonatomic, readonly) NSString *offlinePublicKey;
@property (nonatomic, readonly) NSString *onlinePublicKey;

@property (nonatomic, readonly) NSString *offlinePrivateKey;
@property (nonatomic, readonly) NSString *onlinePrivateKey;


@optional
// 一些额外的请求头信息
- (NSDictionary *)extraHttpHeadParmsWithMethodName:(NSString *)method;
- (BOOL)shouldCallBackByFailedOnCallingAPI:(MIURLResponse *)response;

@end




@interface MIService : NSObject


@property (nonatomic, weak, readonly) id <MIServiceProtocol> child;

@property (nonatomic, copy, readonly) NSString *publicKey;
@property (nonatomic, copy, readonly) NSString *privateKey;
@property (nonatomic, copy, readonly) NSString *apiBaseUrl;
@property (nonatomic, copy, readonly) NSString *apiVersion;

- (NSString *)urlGeneratingRuleByMethodName:(NSString *)method;


@end
