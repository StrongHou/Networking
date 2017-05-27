//
//  MIApiProxy.h
//  MINetWorking
//
//  Created by houxq on 2017/5/25.
//  Copyright © 2017年 MI. All rights reserved.
//  网络请求

#import <Foundation/Foundation.h>
@class MIURLResponse;

typedef void(^ApiCallBack)(MIURLResponse *response);

@interface MIApiProxy : NSObject

+ (instancetype)sharedInstance;


- (NSUInteger)API_GETWithParams:(NSDictionary *)params
          serviceIdentifier:(NSString *)serviceIdentifier
                 methodName:(NSString *)methodName
                    success:(ApiCallBack)success
                    failure:(ApiCallBack)failure;

- (NSUInteger)API_POSTWithParams:(NSDictionary *)params
         serviceIdentifier:(NSString *)serviceIdentifier
                methodName:(NSString *)methodName
                   success:(ApiCallBack)success
                   failure:(ApiCallBack)failure;

- (NSUInteger)API_PUTWithParams:(NSDictionary *)params
          serviceIdentifier:(NSString *)serviceIdentifier
                 methodName:(NSString *)methodName
                    success:(ApiCallBack)success
                    failure:(ApiCallBack)failure;

- (NSUInteger)API_DELETEWithParams:(NSDictionary *)params
            serviceIdentifier:(NSString *)serviceIdentifier
                   methodName:(NSString *)methodName
                      success:(ApiCallBack)success
                      failure:(ApiCallBack)failure;


- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray <NSNumber *> *)requestIdList;


@end
