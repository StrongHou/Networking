//
//  MIRequestFactory.h
//  MINetWorking
//
//  Created by houxq on 2017/5/25.
//  Copyright © 2017年 MI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIRequestFactory : NSObject

+ (instancetype)sharedInstance;

- (NSURLRequest *)GETRequestWithServiceIdentifier:(NSString *)serviceIdentifier
                                     requestParms:(id)requestParams
                                       methodName:(NSString *)methodName;


- (NSURLRequest *)PostRequestWithServiceIdentifier:(NSString *)serviceIdentifier
                                     requestParms:(id)requestParams
                                       methodName:(NSString *)methodName;

- (NSURLRequest *)PUTRequestWithServiceIdentifier:(NSString *)serviceIdentifier
                                     requestParms:(id)requestParams
                                       methodName:(NSString *)methodName;

- (NSURLRequest *)DELETERequestWithServiceIdentifier:(NSString *)serviceIdentifier
                                     requestParms:(id)requestParams
                                       methodName:(NSString *)methodName;



@end
