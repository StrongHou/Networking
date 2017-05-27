//
//  NSURLRequest+MI.m
//  MINetWorking
//
//  Created by houxq on 2017/5/26.
//  Copyright © 2017年 MI. All rights reserved.
//

#import "NSURLRequest+MI.h"
#import <objc/runtime.h>


static void *MINetWorkingRequestParams = &MINetWorkingRequestParams;

@implementation NSURLRequest (MI)

- (void)setRequestParams:(id)requestParams
{
    objc_setAssociatedObject(self, MINetWorkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (id)requestParams
{
    return objc_getAssociatedObject(self, MINetWorkingRequestParams);

}

@end
