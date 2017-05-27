//
//  MIServiceFactory.h
//  MINetWorking
//
//  Created by houxq on 2017/5/25.
//  Copyright © 2017年 MI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIService.h"


@protocol MIServiceFactoryDataSource <NSObject>

- (NSDictionary<NSString *,NSString *> *)servicesKindsOfServiceFactory;

@end


@interface MIServiceFactory : NSObject

@property (nonatomic, weak) id <MIServiceFactoryDataSource> dataSource;

+ (instancetype)sharedInstance;
- (MIService<MIServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier;


@end
