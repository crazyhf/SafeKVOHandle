//
//  NSObject+KVOHelper.m
//  SafeKVOHandle
//
//  Created by crazylhf on 15/10/9.
//  Copyright (c) 2015年 crazylhf. All rights reserved.
//

#import "NSObject+KVOHelper.h"

#import <objc/runtime.h>

@implementation NSObject (KVOHelper)

#pragma mark - hfKVOHandler setter and getter

- (void)setHfKVOHandler:(SafeKVOHandle *)hfKVOHandler
{
    objc_setAssociatedObject(self, @selector(hfKVOHandler), hfKVOHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SafeKVOHandle *)hfKVOHandler
{
    SafeKVOHandle * _handler = objc_getAssociatedObject(self, _cmd);
    
    if (nil == _handler) {
        _handler = [[SafeKVOHandle alloc] initWithObservedObj:self
                                               reactiveTarget:self];
        [self setHfKVOHandler:_handler];
    }
    
    return _handler;
}

@end
