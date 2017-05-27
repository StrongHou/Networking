//
//  MIService.m
//  MINetWorking
//
//  Created by houxq on 2017/5/25.
//  Copyright © 2017年 MI. All rights reserved.
//

#import "MIService.h"

@interface MIService ()

@property (nonatomic, weak, readwrite) id <MIServiceProtocol> child;

@end


@implementation MIService

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        if([self conformsToProtocol:@protocol(MIServiceProtocol)]){
            
            self.child = (id<MIServiceProtocol>)self;
        }else {
        
            NSAssert(NO, @"你提供的Service没有遵循MIServiceProtocol");
        }
    }
    return self;
}


#pragma mark - public method
- (NSString *)urlGeneratingRuleByMethodName:(NSString *)method
{
    NSString *urlString = nil;
    
    if(self.apiVersion.length > 0){
    
        urlString = [NSString stringWithFormat:@"%@/%@/%@",self.apiBaseUrl,self.apiVersion,method];
    }else {
    
        urlString = [NSString stringWithFormat:@"%@/%@",self.apiBaseUrl,method];
    }
    
    return urlString;

}


#pragma mark - getters and setters
- (NSString *)privateKey
{
    return self.child.isOnline?self.child.onlinePrivateKey:self.child.offlinePrivateKey;
}

- (NSString *)publicKey
{
    return self.child.isOnline?self.child.onlinePublicKey:self.child.offlinePublicKey;

}

- (NSString *)apiBaseUrl
{
    return self.child.isOnline?self.child.onlineApiBaseUrl:self.child.offlineApiBaseUrl;
}

- (NSString *)apiVersion
{
    return self.child.isOnline?self.child.onlineApiVersion:self.child.offlineApiVersion;
}

@end
