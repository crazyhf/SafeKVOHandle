//
//  ViewController.m
//  SafeKVOHandle
//
//  Created by crazylhf on 15/10/8.
//  Copyright (c) 2015年 crazylhf. All rights reserved.
//

#import "ViewController.h"

#import "SafeKVOHandle.h"

@interface ViewController ()

@property (nonatomic, assign) BOOL testKVOKey;

@property (nonatomic, strong) SafeKVOHandle * testKVOHandler;

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
    if (nil == self.testKVOHandler) {
        [self onAddSaveKVOHandleAction:nil];
    }
    
    self.testKVOKey = !self.testKVOKey;
}

- (IBAction)onAddSaveKVOHandleAction:(id)sender
{
    self.testKVOHandler = [SafeKVOHandle KVOHandler:self keyPath:@"testKVOKey" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld target:self selector:@selector(onTestKVOKeyChanged:)];
}

- (IBAction)onRemoveSaveKVOHandleAction:(id)sender
{
    self.testKVOHandler = nil;
}


#pragma mark - KVO handle

- (void)onTestKVOKeyChanged:(NSDictionary *)change
{
    [[[UIAlertView alloc] initWithTitle:@"testKVOKey changed" message:change.description delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
}


#pragma mark - memory handle

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
