//
//  NSObject+DefaultValue.m
//  MINetWorking
//
//  Created by houxq on 2017/5/26.
//  Copyright © 2017年 MI. All rights reserved.
//

#import "NSObject+DefaultValue.h"

@implementation NSObject (DefaultValue)


- (id)MI_defaultValue:(id)defaultValue
{
//    if (![defaultValue isKindOfClass:[self class]]) {
//        return defaultValue;
//    };
    
    if([self MI_isEmptyObject]){
        return defaultValue;
    }
    return self;
}


- (BOOL)MI_isEmptyObject
{
    if([self isEqual:[NSNull null]]){
        return YES;
    }
    
    if([self isKindOfClass:[NSString class]]){
        if([(NSString *)self length] == 0){
            return YES;
        }
    }
    
    if([self isKindOfClass:[NSArray class]]){
        if([(NSArray *)self count] == 0){
            return YES;
        }
    }
    if([self isKindOfClass:[NSDictionary class]]){
        if([(NSDictionary *)self count] == 0){
            return YES;
        }
        
    }
    return NO;
}


@end
