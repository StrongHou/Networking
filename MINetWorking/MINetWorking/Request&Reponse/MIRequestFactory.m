//
//  MIRequestFactory.m
//  MINetWorking
//
//  Created by houxq on 2017/5/25.
//  Copyright © 2017年 MI. All rights reserved.
//

#import "MIRequestFactory.h"
#import <AFNetworking.h>
#import "MIServiceFactory.h"
#import "NSURLRequest+MI.h"
#import "MINetworkConfigurationManager.h"



@interface MIRequestFactory ()
// AFN中用来管理Http序列化的类
@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation MIRequestFactory

static  id sharedInstance_ = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance_ = [[self alloc] init];
    });
    return sharedInstance_;
}



#pragma mark - public methods
- (NSURLRequest *)GETRequestWithServiceIdentifier:(NSString *)serviceIdentifier
                                      requestParms:(NSDictionary *)requestParams
                                       methodName:(NSString *)methodName
{
    
    return [self generateRequestWithServiceIdentifier:serviceIdentifier requestParams:requestParams methodName:methodName requestWithMethod:@"GET"];

}

- (NSURLRequest *)PostRequestWithServiceIdentifier:(NSString *)serviceIdentifier
                                      requestParms:(NSDictionary *)requestParams
                                        methodName:(NSString *)methodName
{
    
    return [self generateRequestWithServiceIdentifier:serviceIdentifier requestParams:requestParams methodName:methodName requestWithMethod:@"POST"];
}

- (NSURLRequest *)PUTRequestWithServiceIdentifier:(NSString *)serviceIdentifier
                                     requestParms:(NSDictionary *)requestParams
                                       methodName:(NSString *)methodName
{
    return [self generateRequestWithServiceIdentifier:serviceIdentifier requestParams:requestParams methodName:methodName requestWithMethod:@"PUT"];

}

- (NSURLRequest *)DELETERequestWithServiceIdentifier:(NSString *)serviceIdentifier
                                        requestParms:(NSDictionary *)requestParams
                                          methodName:(NSString *)methodName
{
    return [self generateRequestWithServiceIdentifier:serviceIdentifier requestParams:requestParams methodName:methodName requestWithMethod:@"DELETE"];
}


- (NSURLRequest *)generateRequestWithServiceIdentifier:(NSString *)serviceIdentifier
                                         requestParams:(NSDictionary *)requestParams
                                            methodName:(NSString *)methodName
                                     requestWithMethod:(NSString *)method
{
    // 请求URL
    MIService *service = [[MIServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *urlString = [service urlGeneratingRuleByMethodName:methodName];
    
    // 组装request
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:method URLString:urlString parameters:requestParams error:NULL];
    // 添加额外的请求头信息
    if([service.child respondsToSelector:@selector(extraHttpHeadParmsWithMethodName:)]){
        NSDictionary *dict = [service.child extraHttpHeadParmsWithMethodName:method];
        if(dict){
        
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                // 设置额外的请求头信息
                [request setValue:obj forHTTPHeaderField:key];
            }];
        
        }
    }
    
    request.requestParams = requestParams;
    return request ;
}


#pragma mark - getters and setters

- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if(_httpRequestSerializer == nil){
    
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = [MINetworkConfigurationManager sharedInstance].timeOutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    }
    return _httpRequestSerializer;

}

@end
