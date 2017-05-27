//
//  MIServiceDemo.m
//  MINetWorking
//
//  Created by houxq on 2017/5/25.
//  Copyright © 2017年 MI. All rights reserved.
//

#import "MIServiceDemo.h"

@implementation MIServiceDemo
- (BOOL)isOnline
{
    return YES;
}

- (NSString *)offlineApiBaseUrl
{
    return @"https://jr.jiayuan.com";
}

- (NSString *)onlineApiBaseUrl
{
    return @"https://jr.jiayuan.com";
}

- (NSString *)offlineApiVersion
{
    return @"";
}

- (NSString *)onlineApiVersion
{
    return @"";
}

- (NSString *)onlinePublicKey
{
    return @"384ecc4559ffc3b9ed1f81076c5f8424";
}

- (NSString *)offlinePublicKey
{
    return @"384ecc4559ffc3b9ed1f81076c5f8424";
}

- (NSString *)onlinePrivateKey
{
    return @"";
}

- (NSString *)offlinePrivateKey
{
    return @"";
}


@end
