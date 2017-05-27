//
//  MIURLResponse.m
//  MINetWorking
//
//  Created by houxq on 2017/5/25.
//  Copyright © 2017年 MI. All rights reserved.
//

#import "MIURLResponse.h"
#import "NSURLRequest+MI.h"

@interface MIURLResponse ()

@property (nonatomic, assign, readwrite) MIURLResponseStatus status;
@property (nonatomic, copy, readwrite) NSString *contentString;
@property (nonatomic, copy, readwrite) id content;
@property (nonatomic, assign, readwrite) NSInteger requestId;
@property (nonatomic, copy, readwrite) NSURLRequest *request;
@property (nonatomic, copy, readwrite) NSData *responseData;
@property (nonatomic, strong, readwrite) NSError *error;
@property (nonatomic, assign, readwrite) BOOL isCache;

@end


@implementation MIURLResponse


#pragma mark - life cycle


- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error
{

    self = [super init];
    if(self){
    
        self.contentString = responseString;
        self.status = [self responseStatusWithError:error];
        self.requestId = [requestId integerValue];
        self.request = request;
        self.responseData = responseData;
        self.isCache = NO;
        self.error = error;
        self.requestParams = request.requestParams;
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        } else {
            self.content = nil;
        }
        
    }
    return self;

}


- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        self.contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.status = [self responseStatusWithError:nil];
        self.requestId = 0;
        self.request = nil;
        self.responseData = [data copy];
        self.content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        self.isCache = YES;
    }
    return self;
}


#pragma mark - private method

- (MIURLResponseStatus)responseStatusWithError:(NSError *)error
{
    
    if(error){
        
        MIURLResponseStatus result = MIURLResponseStatusErrorNonetWork;
        
        if(error.code == NSURLErrorTimedOut){
        
            result = MIURLResponseStatusErrorTimeout;
        }
        return result;
    }
    return MIURLResponseStatusSuccess;

}

@end
