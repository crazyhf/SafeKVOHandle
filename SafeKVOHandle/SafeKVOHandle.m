//
//  SafeKVOHandle.m
//  SafeKVOHandle
//
//  Created by crazylhf on 15/10/8.
//  Copyright (c) 2015年 crazylhf. All rights reserved.
//

#import <objc/runtime.h>

#import "SafeKVOHandle.h"


@interface SafeKVOHandle()

@property (nonatomic, copy) NSString * observedKeyPath;

/// must be strong policy
@property (nonatomic, strong) NSObject * observedObj;

@end


@implementation SafeKVOHandle

+ (instancetype)KVOHandler:(NSObject *)object
                   keyPath:(NSString *)keyPath
                   options:(NSKeyValueObservingOptions)options
                    target:(id)target selector:(SEL)selector
{
    return [[self alloc] initWithObservedObj:object keyPath:keyPath options:options target:target selector:selector];
}


- (id)initWithObservedObj:(NSObject *)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options target:(id)target selector:(SEL)selector
{
    NSAssert(nil != keyPath, @"keyPath mustn't be nil");
    
    if (self = [super init]) {
        self.observedKeyPath = keyPath;
        self.observedObj = object;
        
        self.KVOTarget   = target;
        self.KVOSelector = selector;
        
        [self.observedObj addObserver:self
                           forKeyPath:self.observedKeyPath
                              options:options context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self.observedObj removeObserver:self
                          forKeyPath:self.observedKeyPath context:nil];
}


#pragma mark - KVO handle

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.observedObj == object
        && YES == [self.observedKeyPath isEqualToString:keyPath]) {
        if (YES == [self.KVOTarget respondsToSelector:self.KVOSelector])
        {
            Method aKVOMethod = class_getInstanceMethod(object_getClass(self.KVOTarget), self.KVOSelector);
            
            /**
             *  ios method type encoding : https://code.google.com/p/jscocoa/wiki/MethodEncoding
             */
            const char * aTypeEncoding = (8 == sizeof(id) ? "v24@0:8@16" : "v12@0:4@8");
            
            if (0 == strcmp(method_getTypeEncoding(aKVOMethod), aTypeEncoding))
            {
                IMP aKVOImp = class_getMethodImplementation(object_getClass(self.KVOTarget), self.KVOSelector);
                ((void(*)(id, SEL, NSDictionary *))aKVOImp)(self.KVOTarget, self.KVOSelector, change);
            }
        }
    }
}

@end
