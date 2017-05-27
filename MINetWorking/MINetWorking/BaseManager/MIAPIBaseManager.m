//
//  MIAPIBaseManager.m
//  MINetWorking
//
//  Created by houxq on 2017/5/26.
//  Copyright © 2017年 MI. All rights reserved.
//

#import "MIAPIBaseManager.h"
#import "MINetworkConfigurationManager.h"
#import "MIApiProxy.h"
#import "MIService.h"
#import "MIServiceFactory.h"

#define MICALLAPI(METHOD,REQUEST_ID) \
{                                    \
__weak typeof(self) weakSelf = self; \
REQUEST_ID =[[MIApiProxy sharedInstance] API_##METHOD##WithParams:params serviceIdentifier:self.child.serviceIdentifier methodName:self.child.methodName success:^(MIURLResponse *response) {\
__strong typeof(weakSelf) strongSelf = weakSelf;\
[strongSelf successedOnCallingAPI:response];\
} failure:^(MIURLResponse *response) {\
__strong typeof(weakSelf) strongSelf = weakSelf;\
[strongSelf failedOnCallingAPI:response withErrorType:MIAPIManagerErrorTypeDefault];\
}];\
}\


@interface MIAPIBaseManager ()
@property (nonatomic, readwrite) MIAPIManagerErrorType errorType;
@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic, strong) NSMutableArray *requestIdList;
@property (nonatomic, strong, readwrite) MIURLResponse *reponose;

@property (nonatomic, strong, readwrite) id fetchedRawData;
@end


@implementation MIAPIBaseManager

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _dataVerify = nil;
        _paramDataSource = nil;
        
        _fetchedRawData = nil;
        _errorType = MIAPIManagerErrorTypeDefault;
        
        if([self conformsToProtocol:@protocol(MIAPIManager)]){
            self.child = (id <MIAPIManager>)self;
        }else{
            
            NSAssert(NO, @"没有遵循CTAPIManager协议");
        }
        
    }
    return self;
}

- (void)dealloc
{
    [self cancelAllRequests];
    _requestIdList = nil;
}


#pragma mark - public methods
- (void)cancelAllRequests
{
    [[MIApiProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSUInteger)requestID
{
    [self removeRequestIdWithRequestID:requestID];
    [[MIApiProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

- (id)dataWithDataProcessing:(id<MIAPIManagerCallBackDataProcessing>)dataProcessing
{
    id resultData = nil;
    if(dataProcessing){
        resultData = [dataProcessing manager:self dataProcessing:self.fetchedRawData];
    }else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}
- (NSUInteger)callApi
{
    NSDictionary *params = [self.paramDataSource paramsForManger:self];

    return [self callApiWithParams:params];
}



- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
    BOOL result = YES;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)]) {
        result = [self.interceptor manager:self shouldCallAPIWithParams:params];
    }
    return result;
}
- (void)didCallAPIWithParams:(NSDictionary *)params
{
    if(self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:didCallAPIWithParams:)]){
    
        [self.interceptor manager:self didCallAPIWithParams:params];
    
    }
}

- (BOOL)shouldPerformSuccessWithResponse:(MIURLResponse *)response
{
    
    BOOL result = YES;
    if(self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldPerformSuccessWithResponse:)]){
    
        result = [self.interceptor manager:self shouldPerformSuccessWithResponse:response];
    }
    return result;
}

- (void)didPerformSuccessWithResponse:(MIURLResponse *)response
{
    if(self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:didPerformSuccessWithResponse:)]){
    
        [self.interceptor manager:self didPerformSuccessWithResponse:response];
    }

}

- (BOOL)shouldPerformFailureWithResponse:(MIURLResponse *)response
{

    BOOL result = YES;
    if(self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldPerformFailureWithResponse:)]){
    
        [self.interceptor manager:self shouldPerformFailureWithResponse:response];
    }
    return result;
}

- (void)didPerformFailureWithResponse:(MIURLResponse *)response
{
    if(self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:didPerformFailureWithResponse:)]){
        [self.interceptor manager:self didPerformFailureWithResponse:response];
    
    }
}

#pragma mark - private methods
- (NSInteger)callApiWithParams:(NSDictionary *)params
{
    NSUInteger requestID = 0;
    
    if([self shouldCallAPIWithParams:params]){
        if([self.dataVerify manager:self isCorrectWithParamsData:params]){
            
            if(self.isReachabel){
                self.isLoading =YES;
                switch (self.child.requestType) {
                    case MIAPIManagerRequestTypeGet:
                        MICALLAPI(GET, requestID);
                        break;
                    case MIAPIManagerRequestTypePost:
                        MICALLAPI(POST, requestID);
                        break;
                    case MIAPIManagerRequestTypePut:
                        MICALLAPI(PUT, requestID);
                        break;
                    case MIAPIManagerRequestTypeDelete:
                        MICALLAPI(DELETE, requestID);
                        break;
                    default:
                        break;
                }
                [self.requestIdList addObject:@(requestID)];
                NSMutableDictionary *para = [params mutableCopy];
                para[kMIAPIBaseManagerRequestID] = @(requestID);
                [self didCallAPIWithParams:para];
            }else {
                
                [self failedOnCallingAPI:nil withErrorType:MIAPIManagerErrorTypeNoNetWork];
                
            }
            
        }else {
            
            [self failedOnCallingAPI:nil withErrorType:MIAPIManagerErrorTypeParamDataError];
        }
    }else {
        
        [self failedOnCallingAPI:nil withErrorType:MIAPIManagerErrorTypeDefault];
    }
    
    return requestID;
}



- (void)successedOnCallingAPI:(MIURLResponse *)response
{
    self.isLoading = NO;
    self.reponose = response;
    [self removeRequestIdWithRequestID:response.requestId];
    
    if(response.content){
        self.fetchedRawData = [response.content copy];
        
    }else {
        self.fetchedRawData = [response.responseData copy];
    }
    
    if([self.dataVerify manager:self isCorrectWithCallBackData:response.content]){
        
        if([self shouldPerformSuccessWithResponse:response]){
            
            [self.delegate managerCallAPIDidSuccess:self];
            
        }
        [self didPerformSuccessWithResponse:response];
    }else {
        [self failedOnCallingAPI:response withErrorType:MIAPIManagerErrorTypeNoContent];
    }
    
}

- (void)failedOnCallingAPI:(MIURLResponse *)response withErrorType:(MIAPIManagerErrorType)errorType
{
    self.isLoading = NO;
    self.reponose = response;
    self.errorType = errorType;
    NSString *serviceIdentifier = self.child.serviceIdentifier;
    MIService *service = [[MIServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    BOOL needCallBack = YES;
    if([service.child respondsToSelector:@selector(shouldCallBackByFailedOnCallingAPI:)]){
        
        needCallBack = [service.child shouldCallBackByFailedOnCallingAPI:response];
    }
    if(!needCallBack) return;
    if(response.content){
        self.fetchedRawData = [response.content copy];
        
    }else {
        self.fetchedRawData = [response.responseData copy];
    }
    [self removeRequestIdWithRequestID:response.requestId];
    
    if([self shouldPerformFailureWithResponse:response]){
        [self.delegate managerCallAPIDidFailure:self];
    }
    [self didPerformFailureWithResponse:response];
    
}

#pragma mark - getters and setters
- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}
- (BOOL)isReachabel
{
    BOOL isReachability = [MINetworkConfigurationManager sharedInstance].isReachable;
    if (!isReachability) {
        self.errorType = MIAPIManagerErrorTypeNoNetWork;
    }
    return isReachability;
}
@end
