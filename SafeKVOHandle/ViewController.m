//
//  ViewController.m
//  SafeKVOHandle
//
//  Created by crazylhf on 15/10/8.
//  Copyright (c) 2015年 crazylhf. All rights reserved.
//

#import "ViewController.h"

#import "NSObject+KVOHelper.h"

@interface TestObject0 : NSObject

@property (nonatomic, strong) NSString * testKVOKey0;

@end

@implementation TestObject0
@end

@interface TestObject1 : NSObject

@property (nonatomic, strong) NSString * testKVOKey1;

@property (nonatomic, strong) TestObject0 * testObject0;

@end

@implementation TestObject1
@end


@interface ViewController ()

@property (nonatomic, strong) TestObject1 * testObject1;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self onAddSaveKVOHandleAction:nil];
}


#pragma mark - ui action

- (IBAction)onTestSaveKVOHandleAction:(id)sender
{
    if (nil != self.testObject1) {
        self.testObject1 = nil;
    } else {
        self.testObject1 = [[TestObject1 alloc] init];
        self.testObject1.testObject0 = [[TestObject0 alloc] init];
        self.testObject1.testKVOKey1 = @"";
        self.testObject1.testObject0.testKVOKey0 = @"";
    }
}

- (IBAction)onAddSaveKVOHandleAction:(id)sender
{
    [self.hfKVOHandler addObserveKeyPath:@"testObject1"
                        reactiveSelector:@selector(onTestObject1Changed:)
                                 options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld];
    [self.hfKVOHandler addObserveKeyPath:@"testObject1.testObject0"
                        reactiveSelector:@selector(onTestObject0Changed:)
                                 options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld];
    [self.hfKVOHandler addObserveKeyPath:@"testObject1.testKVOKey1"
                        reactiveSelector:@selector(onTestKVOKey1Changed:)
                                 options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld];
    [self.hfKVOHandler addObserveKeyPath:@"testObject1.testObject0.testKVOKey0"
                        reactiveSelector:@selector(onTestKVOKey0Changed:)
                                 options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld];
}

- (IBAction)onRemoveSaveKVOHandleAction:(id)sender
{
    [self.hfKVOHandler clearAllObservedKeyPath];
}


#pragma mark - KVO handle

- (void)onTestObject1Changed:(NSDictionary *)change
{
    NSLog(@"testObject1 changed : %@", change);
}

- (void)onTestObject0Changed:(NSDictionary *)change
{
    NSLog(@"testObject0 changed : %@", change);
}

- (void)onTestKVOKey1Changed:(NSDictionary *)change
{
    NSLog(@"testKVOKey1 changed : %@", change);
}

- (void)onTestKVOKey0Changed:(NSDictionary *)change
{
    NSLog(@"testKVOKey0 changed : %@", change);
}


#pragma mark - memory handle

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
