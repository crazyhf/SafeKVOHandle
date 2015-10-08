//
//  SafeKVOHandle.h
//  SafeKVOHandle
//
//  Created by crazylhf on 15/10/8.
//  Copyright (c) 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SafeKVOHandle : NSObject

@property (nonatomic, assign) SEL KVOSelector;

@property (nonatomic, weak) id KVOTarget;


+ (instancetype)KVOHandler:(NSObject *)object
                   keyPath:(NSString *)keyPath
                   options:(NSKeyValueObservingOptions)options
                    target:(id)target selector:(SEL)selector;

- (id)initWithObservedObj:(NSObject *)object
                  keyPath:(NSString *)keyPath
                  options:(NSKeyValueObservingOptions)options
                   target:(id)target selector:(SEL)selector;

@end
