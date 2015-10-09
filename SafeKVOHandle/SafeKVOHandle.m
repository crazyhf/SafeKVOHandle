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

/// super -> current
@property (nonatomic, strong) NSMutableDictionary * associateKeyPathDic;

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
        
        self.associateKeyPathDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc
{
    [self clearAllObservedKeyPath];
}


#pragma mark - observe handle

- (void)addObserveKeyPath:(NSString *)keyPath
         reactiveSelector:(SEL)selector
                  options:(NSKeyValueObservingOptions)options
{
    NSAssert(NO == [keyPath hasPrefix:@"."] && NO == [keyPath hasSuffix:@"."],
             @"keyPath[%@] is invalid, can't start/end with '.'", keyPath);
    
    if (YES == [self.keyPathSet containsObject:keyPath]) {
        [self.observedObj removeObserver:self forKeyPath:keyPath context:nil];
    } else {
        [self.keyPathSet addObject:keyPath];
    }
    
    options |= (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld);
    
    [self.observedObj addObserver:self forKeyPath:keyPath options:options context:nil];
    
    [self.KVOSelectorDic setValue:NSStringFromSelector(selector) forKey:keyPath];
    
    NSRange aRange = [keyPath rangeOfString:@"." options:NSBackwardsSearch];
    if (NSNotFound != aRange.location) {
        NSString * superKeyPath = [keyPath substringToIndex:aRange.location];
        if (0 != [superKeyPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
        {
            NSMutableSet * anAssociateKeyPathSet = self.associateKeyPathDic[superKeyPath];
            if (nil == anAssociateKeyPathSet) {
                anAssociateKeyPathSet = [NSMutableSet set];
                self.associateKeyPathDic[superKeyPath] = anAssociateKeyPathSet;
            }
            
            [anAssociateKeyPathSet addObject:keyPath];
            
            if (NO == [self.keyPathSet containsObject:superKeyPath]) {
                [self.observedObj addObserver:self forKeyPath:superKeyPath options:options context:nil];
                [self.keyPathSet addObject:superKeyPath];
            }
        }
    }
}

- (void)removeObserveKeyPath:(NSString *)keyPath
{
    NSAssert(NO == [keyPath hasPrefix:@"."] && NO == [keyPath hasSuffix:@"."],
             @"keyPath[%@] is invalid, can't start/end with '.'", keyPath);
    
    [self.KVOSelectorDic removeObjectForKey:keyPath];
    
    if (0 == [self.associateKeyPathDic[keyPath] count]) {
        if (YES == [self.keyPathSet containsObject:keyPath]) {
            [self.observedObj removeObserver:self forKeyPath:keyPath context:nil];
            [self.keyPathSet removeObject:keyPath];
        }
        
        [self.associateKeyPathDic removeObjectForKey:keyPath];
        
        [self traceRemoveObserveKeyPath:keyPath];
    }
}

- (void)clearAllObservedKeyPath
{
    for (NSString * aKeyPath in self.keyPathSet) {
        [self.observedObj removeObserver:self
                              forKeyPath:aKeyPath context:nil];
    }
    
    [self.keyPathSet removeAllObjects];
    [self.KVOSelectorDic removeAllObjects];
    [self.associateKeyPathDic removeAllObjects];
}


#pragma mark - trace and traverse remove observer

- (void)traceRemoveObserveKeyPath:(NSString *)keyPath
{
    NSRange aRange = [keyPath rangeOfString:@"." options:NSBackwardsSearch];
    if (NSNotFound != aRange.location) {
        NSString * superKeyPath = [keyPath substringToIndex:aRange.location];
        if (0 != [superKeyPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
        {
            NSMutableSet * anAssociateKeyPathSet = self.associateKeyPathDic[superKeyPath];
            [anAssociateKeyPathSet removeObject:keyPath];
            
            if (0 == anAssociateKeyPathSet.count) {
                [self.associateKeyPathDic removeObjectForKey:superKeyPath];
                
                if (nil == self.KVOSelectorDic[superKeyPath]) {
                    if (YES == [self.keyPathSet containsObject:superKeyPath]) {
                        [self.observedObj removeObserver:self forKeyPath:superKeyPath context:nil];
                        [self.keyPathSet removeObject:superKeyPath];
                    }
                    [self traceRemoveObserveKeyPath:superKeyPath];
                }
            }
        }
    }
}

- (void)traverseRemoveObserveKeyPath:(NSString *)keyPath
{
    for (NSString * anAssociateKeyPath in self.associateKeyPathDic[keyPath])
    {
        [self.KVOSelectorDic removeObjectForKey:anAssociateKeyPath];
        
        if (YES == [self.keyPathSet containsObject:anAssociateKeyPath]) {
            [self.observedObj removeObserver:self forKeyPath:anAssociateKeyPath context:nil];
            [self.keyPathSet removeObject:anAssociateKeyPath];
        }
        
        [self traverseRemoveObserveKeyPath:anAssociateKeyPath];
        
        [self.associateKeyPathDic removeObjectForKey:anAssociateKeyPath];
    }
}


#pragma mark - KVO handle

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.observedObj == object && YES == [self.keyPathSet containsObject:keyPath])
    {
        if (YES == [change[NSKeyValueChangeNewKey] isKindOfClass:[NSNull class]]
            && NO == [change[NSKeyValueChangeOldKey] isKindOfClass:[NSNull class]])
        {
            [self traverseRemoveObserveKeyPath:keyPath];
            
            [self.associateKeyPathDic removeObjectForKey:keyPath];
        }
        
        SEL aKVOSelector = nil;
        NSString * aSelectorName = [self.KVOSelectorDic valueForKey:keyPath];
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
