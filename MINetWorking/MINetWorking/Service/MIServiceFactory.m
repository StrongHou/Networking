//
//  MIServiceFactory.m
//  MINetWorking
//
//  Created by houxq on 2017/5/25.
//  Copyright © 2017年 MI. All rights reserved.
//

#import "MIServiceFactory.h"

@interface MIServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end


@implementation MIServiceFactory

static id sharedInstance_ = nil;

#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
 
    dispatch_once(&onceToken, ^{
        sharedInstance_ = [[self alloc] init];
    });
    return sharedInstance_;
}


#pragma mark - getters and setters
- (NSMutableDictionary *)serviceStorage
{
    if(_serviceStorage == nil){
        
        _serviceStorage = [[NSMutableDictionary alloc] init];
    
    }
    return _serviceStorage;
}

#pragma mark - public methods
- (MIService<MIServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier
{
    
   NSAssert(self.dataSource, @"必须为MIServiceFactory提供数据源");

    if(self.serviceStorage[identifier] == nil) {
    
        self.serviceStorage[identifier] = [self createNewServiceWithIdentifier:identifier];
    }
    
    return self.serviceStorage[identifier];
}

#pragma mark - private methods
- (MIService<MIServiceProtocol> *)createNewServiceWithIdentifier:(NSString *)identifier
{
    NSAssert([self.dataSource respondsToSelector:@selector(servicesKindsOfServiceFactory)], @"请实现MIServiceFactoryDataSource的serviceWithIdentifier:方法");
    id service = nil;
    if([[self.dataSource servicesKindsOfServiceFactory] valueForKey:identifier]){
    
        NSString *classStr = [[self.dataSource servicesKindsOfServiceFactory] valueForKey:identifier];
        service = [[NSClassFromString(classStr) alloc] init];
        NSAssert(service, [NSString stringWithFormat:@"无法创建service，请检查serviceWithIdentifier:提供的数据是否正确"],service);
        
    
    }else {
         NSAssert(NO, @"serviceWithIdentifier:中无法找不到相匹配identifier");
    }
    
    return service;
}


@end
