//
//  NSObject+DefaultValue.h
//  MINetWorking
//
//  Created by houxq on 2017/5/26.
//  Copyright © 2017年 MI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DefaultValue)


/**
 如果自身为空，使用默认值

 @param defaultValue 默认值
 @return 返回自身或者默认值
 */
- (id)MI_defaultValue:(id)defaultValue;

/**
 判断自身是否为空
   1、null
   2、NSString的length = 0
   3、NSArray的count = 0
   4、NSDictionary的count = 0
 */
- (BOOL)MI_isEmptyObject;


@end
