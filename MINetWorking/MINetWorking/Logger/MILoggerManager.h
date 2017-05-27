//
//  MIHttpLogger.h
//  MINetWorking
//
//  Created by houxq on 2017/5/26.
//  Copyright © 2017年 MI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIURLResponse.h"
#import "MIService.h"

@interface MILoggerManager : NSObject


+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName service:(MIService *)service requestParams:(id)requestParams httpMethod:(NSString *)httpMethod;
+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response responseString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error;

@end
