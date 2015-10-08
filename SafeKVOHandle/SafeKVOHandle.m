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

@property (nonatomic, weak) id KVOTarget;

/// must be strong policy
@property (nonatomic, strong) NSObject * observedObj;

@property (nonatomic, strong) NSMutableSet * keyPathSet;

@property (nonatomic, strong) NSMutableDictionary * KVOSelectorDic;

@end


@implementation SafeKVOHandle

- (id)initWithObservedObj:(NSObject *)object
           reactiveTarget:(id)target
{
    if (self = [super init]) {
        self.observedObj = object;
        self.KVOTarget   = target;
        
        self.keyPathSet     = [NSMutableSet set];
        self.KVOSelectorDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc
{
    for (NSString * aKeyPath in self.keyPathSet) {
        [self.observedObj removeObserver:self
                              forKeyPath:aKeyPath context:nil];
    }
}


#pragma mark - observe handle

- (void)addObserveKeyPath:(NSString *)keyPath
         reactiveSelector:(SEL)selector
                  options:(NSKeyValueObservingOptions)options
{
    if (YES == [self.keyPathSet containsObject:keyPath]) {
        [self.observedObj removeObserver:self forKeyPath:keyPath context:nil];
    } else {
        [self.keyPathSet addObject:keyPath];
    }
    
    [self.observedObj addObserver:self forKeyPath:keyPath options:options context:nil];
    
    [self.KVOSelectorDic setValue:NSStringFromSelector(selector) forKey:keyPath];
}

- (void)removeObserveKeyPath:(NSString *)keyPath
{
    if (YES == [self.keyPathSet containsObject:keyPath]) {
        [self.observedObj removeObserver:self forKeyPath:keyPath context:nil];
        [self.keyPathSet removeObject:keyPath];
    }
    
    [self.KVOSelectorDic removeObjectForKey:keyPath];
}


#pragma mark - KVO handle

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.observedObj == object) {
        SEL aKVOSelector = nil;
        NSString * aSelectorName = [self.KVOSelectorDic valueForKey:[self.keyPathSet member:keyPath]];
        if (nil != aSelectorName) {
            aKVOSelector = NSSelectorFromString(aSelectorName);
        }
        
        if (nil != aKVOSelector && YES == [self.KVOTarget respondsToSelector:aKVOSelector])
        {
            Method aKVOMethod = class_getInstanceMethod(object_getClass(self.KVOTarget), aKVOSelector);
            
            /**
             *  ios method type encoding : https://code.google.com/p/jscocoa/wiki/MethodEncoding
             */
            const char * aTypeEncoding = (8 == sizeof(id) ? "v24@0:8@16" : "v12@0:4@8");
            
            if (0 == strcmp(method_getTypeEncoding(aKVOMethod), aTypeEncoding))
            {
                IMP aKVOImp = class_getMethodImplementation(object_getClass(self.KVOTarget), aKVOSelector);
                ((void(*)(id, SEL, NSDictionary *))aKVOImp)(self.KVOTarget, aKVOSelector, change);
            }
        }
    }
}

@end
