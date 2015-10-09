//
//  SafeKVOHandle.h
//  SafeKVOHandle
//
//  Created by crazylhf on 15/10/8.
//  Copyright (c) 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SafeKVOHandle : NSObject

- (id)initWithObservedObj:(NSObject *)object
           reactiveTarget:(id)target;


- (void)addObserveKeyPath:(NSString *)keyPath
         reactiveSelector:(SEL)selector
                  options:(NSKeyValueObservingOptions)options;

- (void)removeObserveKeyPath:(NSString *)keyPath;


- (void)clearAllObservedKeyPath;

@end
