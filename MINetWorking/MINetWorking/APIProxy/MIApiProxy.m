//
//  MIApiProxy.m
//  MINetWorking
//
//  Created by houxq on 2017/5/25.
//  Copyright © 2017年 MI. All rights reserved.
//

#import "MIApiProxy.h"
#import <AFNetworking.h>
#import "MIURLResponse.h"
#import "MIRequestFactory.h"
#import "MILoggerManager.h"
#import "MINetworkConfigurationManager.h"

@interface MIApiProxy ()

/**
 key:task id value:task
 */
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordRequestID;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end



@implementation MIApiProxy

static id sharedInstance_ = nil;


#pragma mark - life cycyle
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance_  = [super allocWithZone:zone];
    });
    return sharedInstance_;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance_ = [[self alloc] init];
    });
    return sharedInstance_;
}


#pragma mark - public method
- (NSUInteger)API_GETWithParams:(id)params
          serviceIdentifier:(NSString *)serviceIdentifier
                 methodName:(NSString *)methodName
                    success:(ApiCallBack)success
                    failure:(ApiCallBack)failure
{

    NSURLRequest *request  = [[MIRequestFactory sharedInstance] GETRequestWithServiceIdentifier:serviceIdentifier requestParms:params methodName:methodName];
    
    return [[self callApiWithRequest:request success:success failure:failure] unsignedIntegerValue];
}

- (NSUInteger)API_POSTWithParams:(id)params
           serviceIdentifier:(NSString *)serviceIdentifier
                  methodName:(NSString *)methodName
                     success:(ApiCallBack)success
                     failure:(ApiCallBack)failure
{
    NSURLRequest *request = [[MIRequestFactory sharedInstance] PostRequestWithServiceIdentifier:serviceIdentifier requestParms:params methodName:methodName];
    
    return [[self callApiWithRequest:request success:success failure:failure] unsignedIntegerValue];
}

- (NSUInteger)API_PUTWithParams:(id)params
          serviceIdentifier:(NSString *)serviceIdentifier
                 methodName:(NSString *)methodName
                    success:(ApiCallBack)success
                    failure:(ApiCallBack)failure
{
    NSURLRequest *request  = [[MIRequestFactory sharedInstance] PUTRequestWithServiceIdentifier:serviceIdentifier requestParms:params methodName:methodName];
    
    return [[self callApiWithRequest:request success:success failure:failure] unsignedIntegerValue];

}

- (NSUInteger)API_DELETEWithParams:(id)params
             serviceIdentifier:(NSString *)serviceIdentifier
                    methodName:(NSString *)methodName
                       success:(ApiCallBack)success
                       failure:(ApiCallBack)failure
{

    NSURLRequest *request = [[MIRequestFactory sharedInstance] DELETERequestWithServiceIdentifier:serviceIdentifier requestParms:params methodName:methodName];
    
    return [[self callApiWithRequest:request success:success failure:failure] unsignedIntegerValue];
}


- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(ApiCallBack)success failure:(ApiCallBack)failure
{
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        // 跑到这里的block的时候，就已经是主线程了。
        NSNumber *requestID = @(dataTask.taskIdentifier);
        [self.dispatchTable removeObjectForKey:requestID];
        NSData *responseData = responseObject;
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        MIURLResponse *MIresponse = [[MIURLResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData error:error];
        [MILoggerManager logDebugInfoWithResponse:(NSHTTPURLResponse *)response
                            responseString:responseString
                                   request:request
                                     error:error];
        if(error){
            // 如果请求失败
           
            failure?failure(MIresponse):nil;
            
        }else {
            success?success(MIresponse):nil;
        }
    }];
    // 将请求id加入分发表
    NSNumber *requestId = @([dataTask taskIdentifier]);
    self.dispatchTable[requestId] = dataTask;
    // 执行任务
    [dataTask resume];
    return requestId;

}

- (void)cancelRequestWithRequestIDList:(NSArray<NSNumber *> *)requestIdList
{
    for (NSNumber *requestId in requestIdList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    NSURLSessionDataTask *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

#pragma mark - getters and setters

- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}

@end
