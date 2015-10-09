//
//  NSObject+KVOHelper.h
//  SafeKVOHandle
//
//  Created by crazylhf on 15/10/9.
//  Copyright (c) 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SafeKVOHandle.h"

/**
 *  @brief
 *      an Object Extension, support SafeKVOHandle
 */
@interface NSObject (KVOHelper)

@property (nonatomic, strong, readonly) SafeKVOHandle * hfKVOHandler;

@end
