//
//  MITestManager.m
//  MINetWorking
//
//  Created by houxq on 2017/5/27.
//  Copyright © 2017年 MI. All rights reserved.
//

#import "MITestManager.h"

@interface MITestManager () <MIAPIManagerDataVerify>
@end

@implementation MITestManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataVerify = self;
    }
    return self;
}

- (NSString *)methodName
{
    return @"appSignOn/index";
}

- (NSString *)serviceIdentifier
{
    return @"222";
}
- (MIAPIManagerRequestType)requestType
{
    return MIAPIManagerRequestTypePOST;
}

- (BOOL)manager:(MIAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}
- (BOOL)manager:(MIAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    return YES;
}

@end
