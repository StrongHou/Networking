//
//  NSURLRequest+MI.h
//  MINetWorking
//
//  Created by houxq on 2017/5/26.
//  Copyright © 2017年 MI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (MI)



/**
    请求体信息：可是是以下的一种
    1、可能是一个字典
    2、可能是一个二进制流
 */
@property (nonatomic, copy) id requestParams;

@end
