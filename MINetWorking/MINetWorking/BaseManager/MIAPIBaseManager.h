//
//  MIAPIBaseManager.h
//  MINetWorking
//
//  Created by houxq on 2017/5/26.
//  Copyright © 2017年 MI. All rights reserved.
//

#import "MIURLResponse.h"


@class MIAPIBaseManager;

static NSString *kMIAPIBaseManagerRequestID = @"kMIAPIBaseManagerRequestID";

typedef NS_ENUM(NSUInteger, MIAPIManagerErrorType) {
    
    MIAPIManagerErrorTypeDefault,           // 没有产生过API请求,这个是manager的默认状态
    MIAPIManagerErrorTypeSuccess,           // API请求成功并且返回数据正确
    MIAPIManagerErrorTypeNoContent,         // API请求成功但是返回数据不正确
    MIAPIManagerErrorTypeParamDataError,    // 参数校验错误
    MIAPIManagerErrorTypeTimeout,           // 超时
    MIAPIManagerErrorTypeNoNetWork          // 无网络
    
};


typedef NS_ENUM (NSUInteger, MIAPIManagerRequestType){
    MIAPIManagerRequestTypeGet,
    MIAPIManagerRequestTypePost,
    MIAPIManagerRequestTypePut,
    MIAPIManagerRequestTypeDelete
};


// 这个协议 主要为Http提供请求参数
@protocol MIAPIManagerParamDataSource<NSObject>
@required
- (NSDictionary *)paramsForManger:(MIAPIBaseManager *)manager;
@end

@protocol MIAPIManagerCallBackDelegate <NSObject>
@required
// 请求成功之后的回调
- (void)managerCallAPIDidSuccess:(MIAPIBaseManager *)manager;
// 请求失败之后的回调
- (void)managerCallAPIDidFailure:(MIAPIBaseManager *)manager;
@end


@protocol MIAPIManagerDataVerify <NSObject>
@required
// 调用API之前，进行参数校验
- (BOOL)manager:(MIAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data;
// 服务器返回数据后，对返回的数据进行校验
- (BOOL)manager:(MIAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;
@end

@protocol MIAPIManagerCallBackDataProcessing <NSObject>
@required
// 对服务器返回的数据 进行加工
- (id)manager:(MIAPIBaseManager *)manager dataProcessing:(NSDictionary *)data;

@end

// basemanager 子类需要遵守这个协议
// 这个协议主要是为HTTP 提供请求方法和URL
@protocol MIAPIManager <NSObject>
@required
- (NSString *)methodName;
- (NSString *)serviceIdentifier;
- (MIAPIManagerRequestType)requestType;

@optional
- (void)cleanData;

@end

// AOP
@protocol MIAPIManagerInterceptor <NSObject>
@optional
- (BOOL)manager:(MIAPIBaseManager *)manager shouldPerformSuccessWithResponse:(MIURLResponse *)response;
- (void)manager:(MIAPIBaseManager *)manager didPerformSuccessWithResponse:(MIURLResponse *)response;

- (BOOL)manager:(MIAPIBaseManager *)manager shouldPerformFailureWithResponse:(MIURLResponse *)response;
- (void)manager:(MIAPIBaseManager *)manager didPerformFailureWithResponse:(MIURLResponse *)response;

- (BOOL)manager:(MIAPIBaseManager *)manager shouldCallAPIWithParams:(NSDictionary *)params;
- (void)manager:(MIAPIBaseManager *)manager didCallAPIWithParams:(NSDictionary *)params;

@end


@interface MIAPIBaseManager : NSObject

@property (nonatomic, weak) NSObject<MIAPIManager> *child; // 子类必须要遵守这个协议
@property (nonatomic, weak) id<MIAPIManagerParamDataSource> paramDataSource;
@property (nonatomic, weak) id<MIAPIManagerCallBackDelegate> delegate;
@property (nonatomic, weak) id<MIAPIManagerDataVerify> dataVerify;
@property (nonatomic, weak) id<MIAPIManagerInterceptor> interceptor; //AOP


@property (nonatomic, assign, readonly) MIAPIManagerErrorType errorType;
@property (nonatomic, strong, readonly) MIURLResponse *reponose;


@property (nonatomic, assign, readonly) BOOL isReachabel;
@property (nonatomic, assign, readonly) BOOL isLoading;

- (id)dataWithDataProcessing:(id<MIAPIManagerCallBackDataProcessing>)dataProcessing;

- (NSUInteger)callApi;

- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSUInteger)requestID;

// AOP
- (BOOL)shouldPerformSuccessWithResponse:(MIURLResponse *)response;
- (void)didPerformSuccessWithResponse:(MIURLResponse *)response;

- (BOOL)shouldPerformFailureWithResponse:(MIURLResponse *)response;
- (void)didPerformFailureWithResponse:(MIURLResponse *)response;

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params;
- (void)didCallAPIWithParams:(NSDictionary *)params;
@end
